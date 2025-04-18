#!/bin/bash
set -euo pipefail

# === Configurable environment variables ===
GITHUB_OWNER="${GITHUB_OWNER:-akatsantonis}"                        # GitHub user or org name
GITHUB_REPO="${GITHUB_REPO:-ansible}"                         # GitHub repo name
GITHUB_PAT="${GITHUB_PAT:?GITHUB_PAT environment variable is required}"  # Fine-grained PAT with Actions permissions
RUNNER_NAME="${GITHUB_RUNNER_NAME:-ansible-runner}"         # Runner name
RUNNER_VERSION="${RUNNER_VERSION:-2.323.0}"                     # GitHub Runner version (default: latest as of now)
RUNNER_LABELS="${RUNNER_LABELS-ansible}"                  # Github Runner Labels
RUNNER_DIR="${RUNNER_DIR:-/opt/github-runner}"                  # Installation path
RUNNER_USER="${RUNNER_USER:-ansible-runner}"                   # Github runner system user

# === Derived variables ===
RUNNER_URL="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}"
RUNNER_TGZ="actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/${RUNNER_TGZ}"


# === Ensure runner user exists ===
echo "[*] Creating runner user"
sudo useradd -m -s /bin/bash "$RUNNER_USER" || echo "User $RUNNER_USER already exists"

# === Ensure runner directory exists ===
sudo mkdir -p "$RUNNER_DIR"
sudo chown $RUNNER_USER: $RUNNER_DIR
cd "$RUNNER_DIR"

# === Install runner if not already installed ===
if [[ ! -f "./config.sh" ]]; then
  echo "[+] Downloading GitHub Actions runner v$RUNNER_VERSION..."
  sudo -u $RUNNER_USER curl -sL -o "$RUNNER_TGZ" "$DOWNLOAD_URL"
  sudo -u $RUNNER_USER tar -xzf "$RUNNER_TGZ"
  sudo -u $RUNNER_USER rm "$RUNNER_TGZ"
fi

# === Get registration token from GitHub ===
echo "[+] Requesting GitHub registration token..."
TOKEN_RESPONSE=$(curl -X POST \
  -H "Authorization: Bearer ${GITHUB_PAT}" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token")

echo $TOKEN_RESPONSE
RUNNER_TOKEN=$(echo "$TOKEN_RESPONSE" | grep -oP '"token"\s*:\s*"\K[^"]+')

if [[ -z "$RUNNER_TOKEN" ]]; then
  echo "[!] Failed to retrieve runner registration token. Response:"
  echo "$TOKEN_RESPONSE"
  exit 1
fi

# === Register runner only if not already registered ===
if [[ ! -d ".runner" ]]; then
  echo "[+] Configuring the GitHub runner..."
  sudo -u $RUNNER_USER ./config.sh --unattended \
    --url "$RUNNER_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --work "_work" \
    --labels "$RUNNER_LABELS" \
    --replace
else
  echo "[+] Runner already configured. Skipping registration."
fi

# Derive the service name based on GitHub org/repo and runner name
SERVICE_NAME="actions.runner.${GITHUB_OWNER}-${GITHUB_REPO}.${RUNNER_NAME}.service"

# === Install and start runner as a service (idempotent) ===
if [[ ! -f "/etc/systemd/system/github-runner.service" ]]; then
  echo "[+] Installing runner as a systemd service..."
  sudo ./svc.sh install $RUNNER_USER
  sudo systemctl enable $SERVICE_NAME 
  sudo systemctl start $SERVICE_NAME
else
  echo "[+] GitHub runner systemd service already installed."
  sudo systemctl restart $SERVICE_NAME
fi
