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
ACTION="${ACTION:-update_os_images}"
GITHUB_REF_NAME="${GITHUB_REF_NAME:-main}"  # for merges

# Define Functions
promote_infra() {
  # Safely build the expected_versions JSON using jq directly
  expected_versions=$(jq -n 'reduce inputs as $kv ({}; .[$kv.key] = $kv.val)' \
    --argjson inputs "$(printf '%s\n' "${image_versions[@]}" | jq -R 'split("=") | {key: .[0], val: .[1]}')"
  )

  # Then run the comparison jq
  jq --argjson expected "$expected_versions" '
    if has("image_versions")
       and (.image_versions as $actual
            | ($actual | to_entries | all(.value == $expected[.key])))
    then
      (if has("is_active") then .is_active = true else . end)
      | (if has("provisioned") then .provisioned = true else . end)
    else
      .
    end
  ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"

  if [[ -n $(git status --porcelain) ]]; then
    # Commit changes
    git add .
    git commit -m "tf:$component:$ENVIRONMENT: Promote deployment $deployment"
  fi
}

deprovision_infra() {
  for kv in "${image_versions[@]}"; do
    image_family="${kv%%=*}"
    image_version="${kv#*=}"

    jq --arg key "$image_family" --arg val "$image_version" '
      if has("image_versions") and (.image_versions[$key] != $val) then
        (if has("is_active") then .is_active = false else . end)
        | (if has("provisioned") then .provisioned = false else . end)
      else
        .
      end
    ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
    # Update the value in the tfvars JSON file
  done
  if [[ -n $(git status --porcelain) ]]; then
    # Commit changes
    git add .
    git commit -m "tf:$component:$ENVIRONMENT: Deprovision $deployment deployment"
  fi
}

provision_infra() {
  for kv in "${image_versions[@]}"; do
    image_family="${kv%%=*}"
    image_version="${kv#*=}"
    # Update the value in the tfvars JSON file
    jq --arg key "$image_family" --arg val "$image_version" '
      if has("image_versions") and (.image_versions[$key] == $val) then
        (if has("provisioned") then .provisioned = true else . end)
      else
        .
      end
    ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
  done
  if [[ -n $(git status --porcelain) ]]; then
    # Commit changes
    git add .
    git commit -m "tf:$component:$ENVIRONMENT: Provision deployment $deployment"
  fi
}

update_os_images() {
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
      end
    ' "$tfvars_json" > tmp.json && mv tmp.json "$tfvars_json"
    if [[ -n $(git status --porcelain) ]]; then
      # Commit changes
      git add . 
      git commit -m "tf:$component:$ENVIRONMENT: Update image $image_family of $deployment deployment to version $image_version"
    fi
  done
}

# Configure git
git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

# Clone
cd "$WORK_DIR"
git clone "https://${CICD_TOKEN}@${REPO_URL#https://}" repo
cd repo

# Determine context
if [[ "$GITHUB_REF_NAME" != "main" ]]; then
  echo "Detected push to a feature branch: $GITHUB_REF_NAME"
  BRANCH_NAME="$GITHUB_REF_NAME"	    
  git checkout $BRANCH_NAME
else
  echo "Detected push to default branch. Base branch: $GITHUB_REF_NAME"
  case "$ACTION" in
    deprovision_infra)
      BRANCH_NAME="auto/deprovision_infra_$GITHUB_RUN_ID"	    
      ;;
    update_os_images)
      BRANCH_NAME="auto/update_os_images__$GITHUB_RUN_ID"	    
      ;;
    *)
      echo "Unknown action: $ACTION"
      exit 1
      ;;
  esac
  git checkout -b $BRANCH_NAME "origin/$GITHUB_REF_NAME"
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
    parent_dir=$(dirname "$tfvars_json")
    component=$(basename "$(dirname "$parent_dir")")
    deployment=$(basename "$tfvars_json" | cut -d\. -f1)
    echo "Updating file: $tfvars_json"

    case "$ACTION" in
      deprovision_infra)
        promote_infra 
        deprovision_infra
        ;;
      update_os_images)
        update_os_images
	provision_infra
        ;;
      *)
        echo "Unknown action: $ACTION"
        exit 1
        ;;
    esac
  done
done

# Push commits
if [[ $(git rev-list --count origin/HEAD..HEAD) -gt 0 ]]; then
  echo "New commits found, pushing to remote..."
  git push origin "$BRANCH_NAME"
  echo "✅ Terraform tfvars updated and pushed."
fi
