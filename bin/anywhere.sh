#!/usr/bin/env bash


mkdir -p /tmp/extra-files/etc/ssh
cp /tmp/host-keys/ssh_host_ed25519_key /tmp/extra-files/etc/ssh/
chmod 600 /tmp/extra-files/etc/ssh/ssh_host_ed25519_key

# Run nix-anywhere with --extra-files
nix run github:nix-community/nix-anywhere -- \
  --extra-files /tmp/extra-files \
  --copy-hardware-config ./hosts/nixos-installer/hardware-configuration.nix \
  --flake .#nixos-installer \
  root@192.168.122.245
