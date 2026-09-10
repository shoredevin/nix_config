#!/usr/bin/env bash
TARGET_USER="dshore"
HOST_NAME=""
HOST_IP=""
BRANCH="main"

usage() {
  cat <<EOF
Usage: $(basename "$0") -h <hostname> -i <ip_address> [-u <user>] [-b <branch>]

Bootstraps a new NixOS machine into the local nix_config flake.

Options:
  -h  Host name (e.g., thunkpad, office, livingroom) [Required]
  -i  Host IP address or SSH reachable address [Required]
  -u  SSH user on target host (default: ${TARGET_USER})
  -b  Git branch to push to (default: ${BRANCH})
  -?  Show this help message
EOF
  exit 1
}

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

echo "========================================="
echo " Bootstrapping Host: ${HOST_NAME} (${HOST_IP})"
echo " Target User:       ${TARGET_USER}"
echo " Host Directory:    ${HOST_DIR}"
echo "========================================="

str="nix run github:nix-community/nixos-anywhere --\
 --generate-hardware-config nixos-generate-config \
 ./hosts/nixos-installer/hardware-configuration.nix \
 --flake .#nixos-installer \
 --target-host ${HOST_NAME}t@${HOST_IP}"


echo "$str"
exit 1

nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-generate-config \
  ./hosts/nixos-installer/hardware-configuration.nix \
  --flake .#nixos-installer \
  --target-host root@192.168.122.245
