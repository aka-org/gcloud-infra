#!/usr/bin/env bash

set -euo pipefail

# GitHub environment variables (in GitHub Actions)
CICD_TOKEN="${CICD_TOKEN:-}"
ENVIRONMENT="${ENVIRONMENT:-testing}"
RELEASE_VERSION="${RELEASE_VERSION:-0.0.1}"
GITHUB_REF_NAME="${GITHUB_REF_NAME:-main}"
DEBUG="${1:-${DEBUG:-}}"

# Inputs
REPO_URL="https://github.com/aka-org/gcloud_infra.git"
GIT_EMAIL="41898282+github-actions[bot]@users.noreply.github.com"
GIT_NAME="github-actions[bot]"
RELEASE_MANIFEST="releases/release-manifest.$ENVIRONMENT.json"

update_release_manifest() {
  # Load latest os images key-value pairs from gcloud
  mapfile -t images < <(
    gcloud compute images list \
      --project=$PROJECT \
      --filter="labels.created_by=packer" \
      --format="json" |
    jq -r '
      group_by(.family)
      | map(max_by(.creationTimestamp))
      | map({key: .family, value: .labels.version})
      | from_entries
      | to_entries[]
      | "\(.key)=\(.value)"'
  )

  # Update release manifest
  jq --arg version "$RELEASE_VERSION" \
     --arg git_commit "$GIT_COMMIT" \
     --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
     '
       .version = $version |
       .git_commit = $git_commit |
       .timestamp = $timestamp
     ' "$RELEASE_MANIFEST" > tmp.json && mv tmp.json "$RELEASE_MANIFEST"

  for kv in "${images[@]}"; do
    image_family="${kv%%=*}"
    image_version="${kv#*=}"
    # Update the value in the tfvars JSON file
    jq --arg key "$image_family" --arg val "$image_version" '
      .images[$key] = $val
    ' "$RELEASE_MANIFEST" > tmp.json && mv tmp.json "$RELEASE_MANIFEST"
  done
  if [ -z $DEBUG ]; then
    if [[ -n $(git status --porcelain) ]]; then
      # Commit changes
      git add . 
      git commit -m "tf:releases: Update release manifest of $ENVIRONMENT based on $GIT_COMMIT"
      echo "✅ Release manifest updated."
    fi
  fi
}

update_os_images() {
  for kv in "${images[@]}"; do
    image_family="${kv%%=*}"
    image_version="${kv#*=}"
    # Update the value in the tfvars JSON file
    jq --arg key "$image_family" --arg val "$image_version" --arg version "$RELEASE_VERSION" '
      if has("is_active") and .is_active == true then
        .
      else
        (if has("images") and (.images | has($key))
         then .images[$key] = $val | .release = $version
         else .
         end)
      end
    ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
    if [ -z $DEBUG ]; then
      if [[ -n $(git status --porcelain) ]]; then
        # Commit changes
        git add . 
        git commit -m "tf:$component:$ENVIRONMENT: Update image $image_family of $deployment deployment to version $image_version"
      fi
    fi
  done
}

provision_infra() {
  # Read the release version from the release manifest
  version=$(jq -r '.version' "$RELEASE_MANIFEST")
  # Update the value in the tfvars JSON file
  jq --arg release "$version" '
    if has("release") and (.release == $release) then
      (if has("provisioned") then .provisioned = true else . end)
    else
      .
    end
  ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"

  if [ -z $DEBUG ]; then
    if [[ -n $(git status --porcelain) ]]; then
      # Commit changes
      git add .
      git commit -m "tf:$component:$ENVIRONMENT: Provision deployment $deployment"
    fi
  fi
}

if [ -z $DEBUG ]; then
  WORK_DIR=$(mktemp -d)
  cd "$WORK_DIR"
  # Configure git
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"

  # Clone
  git clone "https://${CICD_TOKEN}@${REPO_URL#https://}" repo
  cd repo

  # Create new branch
  BRANCH_NAME="auto/prepare_release_$RELEASE_VERSION"
  git checkout -b "$BRANCH_NAME" "origin/$GITHUB_REF_NAME"
  GIT_COMMIT="$(git rev-parse HEAD)" 
else
  WORK_DIR=$(pwd)
  GIT_COMMIT="no_commit" 
fi

# Read some values from the release manifest
PROJECT=$(jq -r '.terraform.project' "$RELEASE_MANIFEST")
TFVARS_FILE=$(jq -r '.terraform.tfvars_file' "$RELEASE_MANIFEST")

# Update release manifest
update_release_manifest

# Read the images from the updated release manifest
mapfile -t images < <(
  jq -r '.images | to_entries[] | "\(.key)=\(.value)"' $RELEASE_MANIFEST
)

# Loop through all directories matching ENV name under the root
find "$WORK_DIR" -type d -name "$ENVIRONMENT" | while read -r vars_dir; do
  echo "Processing directory: $vars_dir"

  # For every *.json file under each directory 
  find "$vars_dir" -type f -name "$TFVARS_FILE" | while read -r tfvars_json; do
    parent_dir=$(dirname "$tfvars_json")
    component=$(basename "$(dirname "$parent_dir")")
    deployment=$(basename "$tfvars_json" | cut -d\. -f1)
    echo "Updating file: $tfvars_json"
    # Update image versions of components and deployments
    update_os_images
    # Provision infra for new release
    provision_infra
  done
done

if [ -z $DEBUG ]; then
  # Push commits
  if [[ $(git rev-list --count origin/HEAD..HEAD) -gt 0 ]]; then
    echo "New commits found, pushing to remote..."
    git push origin "$BRANCH_NAME"
    echo "✅ Terraform tfvars updated and pushed."
  fi
fi
