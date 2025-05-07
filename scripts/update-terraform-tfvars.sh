#!/usr/bin/env bash

set -euo pipefail

# Inputs
REPO_URL="https://github.com/aka-org/gcloud_infra.git"
CICD_TOKEN="${CICD_TOKEN:?CICD_TOKEN is required}"
WORK_DIR=$(mktemp -d)
GIT_EMAIL="41898282+github-actions[bot]@users.noreply.github.com"
GIT_NAME="github-actions[bot]"

# GitHub environment variables (in GitHub Actions)
ENVIRONMENT="${ENVIRONMENT:-}"
PROJECT="${PROJECT:-}"
GITHUB_RUN_ID="${GITHUB_RUN_ID:-}"
GITHUB_EVENT_NAME="${GITHUB_EVENT_NAME:-}"
GITHUB_HEAD_REF="${GITHUB_HEAD_REF:-}"  # for PRs
GITHUB_REF_NAME="${GITHUB_REF_NAME:-}"  # for merges


# Configure git
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

# Clone
cd "$WORK_DIR"
git clone "https://${CICD_TOKEN}@${REPO_URL#https://}" repo
cd repo

# Determine context
if [[ "$GITHUB_EVENT_NAME" == "pull_request" ]]; then
  echo "Detected PR event. Branch: $GITHUB_HEAD_REF"
  git checkout "$GITHUB_HEAD_REF"
else
  echo "Detected merge event. Base branch: $GITHUB_REF_NAME"
  git checkout -b "update-images-$GITHUB_RUN_ID" "origin/$GITHUB_REF_NAME"
fi

# Load key-value pairs
mapfile -t image_versions < <(
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

# Loop through all directories matching ENV name under the root
find "$WORK_DIR" -type d -name "$ENVIRONMENT" | while read -r vars_dir; do
  echo "Processing directory: $vars_dir"

  # For every *.json file under each directory 
  find "$vars_dir" -type f -name "*.json" | while read -r tfvars_json; do
    echo "Updating file: $tfvars_json"

    for kv in "${image_versions[@]}"; do
      image_family="${kv%%=*}"
      image_version="${kv#*=}"
      # Update the value in the tfvars JSON file
      jq --arg key "$image_family" --arg val "$image_version" '
        if has("is_active") and .is_active == true then
          .
        else
          (if has("image_versions") and (.image_versions | has($key))
           then .image_versions[$key] = $val
           else .
           end)
          | (if has("provisioned") then .provisioned = true else . end)
        end
      ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
      if [[ -n $(git status --porcelain) ]]; then
        # Commit changes
        git add . 
        git commit -m "packer:images:$image_family: Update image version to $image_version"
      fi
    done
  done
done

# Push commits
git push origin HEAD
echo "✅ Terraform tfvars updated and pushed."
