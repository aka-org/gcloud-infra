#!/usr/bin/env bash

set -euo pipefail

# GitHub environment variables (in GitHub Actions)
CICD_TOKEN="${CICD_TOKEN:-}"
ENVIRONMENT="${ENVIRONMENT:-testing}"
RELEASE="${RELEASE:-0.0.1-testing}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY:-}"
REPO_URL="https://github.com/$GITHUB_REPOSITORY.git"
WORK_DIR=$(mktemp -d)

cd "$WORK_DIR"
# Configure git
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

# Clone
git clone "https://${CICD_TOKEN}@${REPO_URL#https://}" repo
cd repo

git remote set-url origin "https://x-access-token:$CICD_TOKEN@github.com/$GITHUB_REPOSITORY"
git tag -a "v$RELEASE" -m "Release $RELEASE for $ENVIRONMENT environment"
git push origin "v$RELEASE"
