#!/bin/bash

# Check if the required environment variables are set
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set."
  exit 1
fi

if [ -z "$REPO" ]; then
  echo "Error: REPO is not set."
  exit 1
fi

if [ -z "$WORKFLOW_FILE" ]; then
  echo "Error: WORKFLOW_FILE is not set."
  exit 1
fi

# Trigger the workflow
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$REPO/actions/workflows/$WORKFLOW_FILE/dispatches \
  -d '{"ref":"main"}' # Specify the branch to trigger
