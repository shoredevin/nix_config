#!/usr/bin/env bash

# Get the absolute directory path where this script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve the repository root (one level up from bin/)
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Change execution context to the repository root
cd "${REPO_ROOT}"


set -euo pipefail

# Default values
TARGET_USER="dshore"
HOST_NAME=""
HOST_IP=""
BRANCH="main"

# Help output
usage() {
  cat <<EOF
Usage: $(basename "$0") -h <hostname> -i <ip_address> [-u <user>] [-b <branch>]

Bootstraps a new NixOS machine into the local nix_config flake.

Options:
  -h  Host name (e.g., poo, livingroom) [Required]
  -i  Host IP address or SSH reachable address [Required]
  -u  SSH user on target host (default: ${TARGET_USER})
  -b  Git branch to push to (default: ${BRANCH})
  -?  Show this help message
EOF
  exit 1
}

# Parse command line options
while getopts "h:i:u:b:?" opt; do
  case "$opt" in
    h) HOST_NAME="$OPTARG" ;;
    i) HOST_IP="$OPTARG" ;;
    u) TARGET_USER="$OPTARG" ;;
    b) BRANCH="$OPTARG" ;;
    ?) usage ;;
  esac
done

# Validate required arguments
if [[ -z "${HOST_NAME}" || -z "${HOST_IP}" ]]; then
  echo "Error: Host name (-h) and IP address (-i) are required." >&2
  usage
fi

HOST_DIR="./hosts/${HOST_NAME}"

echo "========================================="
echo " Bootstrapping Host: ${HOST_NAME} (${HOST_IP})"
echo " Target User:       ${TARGET_USER}"
echo " Host Directory:    ${HOST_DIR}"
echo "========================================="

# 1. Ensure target directory exists
mkdir -p "${HOST_DIR}"

# 2. Verify / Copy SSH keys to target host
echo -e "\n==> [1/6] Verifying SSH access..."
if ! ssh -o ConnectTimeout=5 -o BatchMode=yes -o StrictHostKeyChecking=accept-new "${TARGET_USER}@${HOST_IP}" exit 2>/dev/null; then
  echo "SSH key access not detected. Copying public key..."
  ssh-copy-id -i ~/.ssh/id_ed25519.pub "${TARGET_USER}@${HOST_IP}"
fi

# 3. Fetch hardware configuration
echo -e "\n==> [2/6] Fetching hardware-configuration.nix..."
scp "${TARGET_USER}@${HOST_IP}:/etc/nixos/hardware-configuration.nix" "${HOST_DIR}/hardware-configuration.nix"

# 4. Extract Age Key from target host
echo -e "\n==> [3/6] Generating Age key from host ED25519 host key..."
HOST_AGE_KEY=$(ssh-keyscan -t ed25519 "${HOST_IP}" 2>/dev/null | nix run nixpkgs#ssh-to-age)

echo "------------------------------------------------------------------"
echo "Generated Age Key for ${HOST_NAME}:"
echo "  ${HOST_AGE_KEY}"
echo "------------------------------------------------------------------"
echo "Action Required: Add the Age key above to .sops.yaml now."
read -p "Press [ENTER] once .sops.yaml has been updated to continue..."

# 5. Update SOPS secrets
echo -e "\n==> [4/6] Updating SOPS secrets..."
sops updatekeys secrets/secrets.yaml

# 6. Stage and Commit Git changes
echo -e "\n==> [5/6] Staging files and committing to Git..."
git add "${HOST_DIR}" .
if ! git diff --cached --quiet; then
	git commit
	git push origin "${BRANCH}"
else
  echo "No changes detected in git workspace. Skipping commit/push."
fi

# 7. Deploy via nixos-rebuild
echo -e "\n==> [6/6] Building and deploying NixOS configuration to ${HOST_NAME}..."
nixos-rebuild switch \
  --flake ".#${HOST_NAME}" \
  --target-host "${TARGET_USER}@${HOST_IP}" \
  --elevate=sudo \
  --ask-elevate-password
