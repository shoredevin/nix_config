#!/usr/bin/env bash
set -euo pipefail

# Create isolated, secure temporary directory
WORK_DIR=$(mktemp -d)

# Configuration values
INSTALL_USER="root"
HOST_NAME="poo"
HOST_IP="192.168.50.91"
BRANCH="main"
HOST_DIR="./hosts/${HOST_NAME}"

# Trapped cleanup ensures deletion on script exit/failure
trap 'rm -rf "${WORK_DIR:-}"' EXIT

# Generate temporary SSH host keys inside the workspace
mkdir -p "$WORK_DIR/host-keys" "$WORK_DIR/extra-files/etc/ssh"
ssh-keygen -q -t ed25519 -N "" -f "$WORK_DIR/host-keys/ssh_host_ed25519_key"

# Copy BOTH private and public keys with strict permissions
cp "$WORK_DIR/host-keys/ssh_host_ed25519_key"* "$WORK_DIR/extra-files/etc/ssh/"
chmod 700 "$WORK_DIR/extra-files/etc/ssh"
chmod 600 "$WORK_DIR/extra-files/etc/ssh/ssh_host_ed25519_key"
chmod 644 "$WORK_DIR/extra-files/etc/ssh/ssh_host_ed25519_key.pub"

# Get Age key for .sops.yaml update
AGE_KEY=$(nix run nixpkgs#ssh-to-age -- -i "$WORK_DIR/host-keys/ssh_host_ed25519_key.pub")

echo "------------------------------------------------------------------"
echo "Generated Age Key for ${HOST_NAME}:"
echo "  ${AGE_KEY}"
echo "------------------------------------------------------------------"
echo "Action Required: Add the Age key above to .sops.yaml now."
read -rp "Press [ENTER] once .sops.yaml has been updated to continue..."

# Update SOPS secrets
echo -e "\n==> Updating SOPS secrets..."
sops updatekeys secrets/secrets.yaml

# Stage and Commit Git changes
echo -e "\n==> Staging files and committing to Git..."
mkdir -p ./hosts/$HOST_NAME
echo "{ ... }: { }" > ./hosts/$HOST_NAME/hardware-configuration.nix
git add "${HOST_DIR}" .
if ! git diff --cached --quiet; then
    git commit
    git push origin "${BRANCH}"
else
    echo "No changes detected in git workspace. Skipping commit/push."
fi

# Execute nix-anywhere
echo -e "\n==> Starting nixos-anywhere deployment..."
nix run github:nix-community/nixos-anywhere -- \
  --extra-files "$WORK_DIR/extra-files" \
  --generate-hardware-config nixos-generate-config ./hosts/nixos-installer/hardware-configuration.nix \
  --flake ".#${HOST_NAME}" \
  "${INSTALL_USER}@${HOST_IP}"
