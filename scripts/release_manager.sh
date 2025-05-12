#!/usr/bin/env bash

set -euo pipefail

# GitHub environment variables (in GitHub Actions)
CICD_TOKEN="${CICD_TOKEN:-}"
ENVIRONMENT="${ENVIRONMENT:-testing}"
RELEASE="${RELEASE:-0.0.1-testing}"
RELEASE_MANIFEST="${RELEASE_MANIFEST:-releases/release-manifest.testing.json}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
GITHUB_REF_NAME="${GITHUB_REF_NAME:-main}"
TAG_REF="${TAG_REF:-}"
ACTION="${ACTION:-ROLLOUT}"
DEBUG="${1:-${DEBUG:-}}"

# Inputs
REPO_URL="https://github.com/$GITHUB_REPOSITORY.git"
GIT_EMAIL="41898282+github-actions[bot]@users.noreply.github.com"
GIT_NAME="github-actions[bot]"

# Define Functions
update_release_manifest_commit() {
  GIT_COMMIT="$(git rev-parse HEAD)" 
  # Update release manifest
  jq --arg git_commit "$GIT_COMMIT" \
     --arg timestamp "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
     '
       .git_commit = $git_commit |
       .timestamp = $timestamp
     ' "$RELEASE_MANIFEST" > tmp.json && mv tmp.json "$RELEASE_MANIFEST"
  if [ -z $DEBUG ]; then
    if [[ -n $(git status --porcelain) ]]; then
      # Commit changes
      git add . 
      git commit -m "tf:releases:$ENVIRONMENT: Update commit sha in release manifest for release $RELEASE"
      echo "✅ Release manifest updated."
    fi
  fi
}

update_release_manifest_versions() {
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
  jq --arg version "$RELEASE" '
       .version = $version
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
      git commit -m "tf:releases:$ENVIRONMENT: Update versions in release manifest for release $RELEASE"
      echo "✅ Release manifest updated."
    fi
  fi
}

git_commit() {
  commit_message="$1"
  if [ -z $DEBUG ]; then
    if [[ -n $(git status --porcelain) ]]; then
      # Commit changes
      git add .
      if [ $ENVIRONMENT == $deployment ];then
        git commit -m "tf:$component:$ENVIRONMENT: $commit_message"
      else
        git commit -m "tf:$component:$ENVIRONMENT:$deployment: $commit_message"
      fi	
    fi
  else
    if [ $ENVIRONMENT == $deployment ];then
      echo "tf:$component:$ENVIRONMENT: $commit_message"
    else
      echo "tf:$component:$ENVIRONMENT:$deployment: $commit_message"
    fi
  fi
}

promote_component() {
  # Read the release version from the release manifest
  version=$(jq -r '.version' "$RELEASE_MANIFEST")
  # Ensure that component is active and provisioned 
  jq --arg release "$version" '
    if has("release") and (.release == $release) then
      (if has("is_active") then .is_active = true else . end)
      | (if has("provisioned") then .provisioned = true else . end)
    else
      .
    end
  ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
  git_commit "Promote componet"
}

deprovision_component() {
  # Read the release version from the release manifest
  version=$(jq -r '.version' "$RELEASE_MANIFEST")
  # Update the value in the tfvars JSON file
  jq --arg release "$version" '
    if has("release") and (.release != $release) then
      (if has("is_active") then .is_active = false else . end)
      | (if has("provisioned") then .provisioned = false else . end)
    else
      .
    end
  ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"

  git_commit "Deprovision component"
}

update_os_images() {
  # Read the images from the updated release manifest
  mapfile -t images < <(
    jq -r '.images | to_entries[] | "\(.key)=\(.value)"' $RELEASE_MANIFEST
  )

  for kv in "${images[@]}"; do
    image_family="${kv%%=*}"
    image_version="${kv#*=}"
    # Update the value in the tfvars JSON file
    jq --arg key "$image_family" --arg val "$image_version" '
      if has("is_active") and .is_active == true then
        .
      else
        (if has("images") and (.images | has($key))
         then .images[$key] = $val else . end)
      end
    ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
     
    git_commit "Update image $image_family to version $image_version"
  done
}

update_release_versions() {
  # Read the release version from the release manifest
  version=$(jq -r '.version' "$RELEASE_MANIFEST")
  # Update the value in the tfvars JSON file
  jq --arg release "$version" '
    if has("is_active") and .is_active == true then
      .
    else
      .release = $release
    end
  ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"

  git_commit "Update release version of component to $version"
}

provision_component() {
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

  git_commit "Provision component"
}

# Main Prep per case of ACTION
if [ -z $DEBUG ]; then
  WORK_DIR=$(mktemp -d)
  cd "$WORK_DIR"
  # Configure git
  git config --global user.email "$GIT_EMAIL"
  git config --global user.name "$GIT_NAME"

  # Clone
  git clone "https://${CICD_TOKEN}@${REPO_URL#https://}" repo
  cd repo

  case $ACTION in
    PREPARE)
      BRANCH_NAME="releases/prepare_release_$RELEASE" 
      git checkout -b "$BRANCH_NAME" "origin/$GITHUB_REF_NAME"
      ;;
    ROLLOUT)
      BRANCH_NAME="releases/rollout_release_$RELEASE" 
      # And release tag for pre and push
      git tag -a "v$RELEASE-pre" -m "Release v$RELEASE-pre for $ENVIRONMENT environment"
      git push origin "v$RELEASE-pre"
      echo "✅ Tagged release v$RELEASE-pre for $ENVIRONMENT environment"
      git checkout -b "$BRANCH_NAME" "origin/$GITHUB_REF_NAME"
      ;;
    POST)
      # And release tag for pre and push
      git tag -a "v$RELEASE" -m "Release v$RELEASE-pre for $ENVIRONMENT environment"
      git push origin "v$RELEASE"
      echo "✅ Tagged release v$RELEASE for $ENVIRONMENT environment"
      exit 0
      ;;
    ROLLBACK)
      echo "Not implemented"
      ;;
    *)
      echo "Unknown action $ACTION specified"	    
      exit 1
      ;;
  esac
else
  WORK_DIR=$(pwd)
  GIT_COMMIT="no_commit" 
fi

# If action is PREPARE update the release manifest
if [ $ACTION == "PREPARE" ]; then
  PROJECT=$(jq -r '.terraform.project' "$RELEASE_MANIFEST")
  update_release_manifest_versions
fi

# Read the suffic of tfvars files we need to read through
TFVARS_FILE=$(jq -r '.terraform.tfvars_file' "$RELEASE_MANIFEST")
# Loop through all directories matching ENV name under the root
find "$WORK_DIR" -type d -name "$ENVIRONMENT" | while read -r vars_dir; do
  echo "Processing directory: $vars_dir"

  # For every *.json file under each directory 
  find "$vars_dir" -type f -name "$TFVARS_FILE" | while read -r tfvars_json; do
    parent_dir=$(dirname "$tfvars_json")
    component=$(basename "$(dirname "$parent_dir")")
    deployment=$(basename "$tfvars_json" | cut -d\. -f1)
    echo "Updating file: $tfvars_json"
    case $ACTION in
      PREPARE)
        # Update image versions of components and deployments
        update_os_images
        # Update image versions of components and deployments
        update_release_versions 
        # Provision infra for new release
        provision_component
        ;;
      ROLLOUT)
        # Promote component with matching release version to current active
        promote_component
        # Deprovisioning component with old release version
        deprovision_component
        ;;
      ROLLBACK)
        echo "Not implemented"
        ;;
    esac
  done
done

if [[ $ACTION == "PREPARE" || $ACTION == "ROLLOUT" ]]; then
  # Add the commit sha of the pre release
  update_release_manifest_commit
fi
if [ -z $DEBUG ]; then
  # Push commits
  if [[ $(git rev-list --count origin/HEAD..HEAD) -gt 0 ]]; then
    echo "New commits found, pushing to remote..."
    git push origin "$BRANCH_NAME"
    echo "✅ Terraform tfvars updated and pushed."
  fi
fi
