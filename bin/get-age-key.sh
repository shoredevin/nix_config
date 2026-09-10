#!/usr/bin/env bash

mkdir -p /tmp/host-keys
ssh-keygen -t ed25519 -N "" -f /tmp/host-keys/ssh_host_ed25519_key

nix run nixpkgs#ssh-to-age -- -i /tmp/host-keys/ssh_host_ed25519_key.pub
