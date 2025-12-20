#!/bin/bash

nversion="$1"

if [[ -z "$nversion" ]]; then
 echo "Please provide a version to update to."
 exit
fi

if [[ "$nversion" == "unstable" ]]; then
	hversion="master"
else
	hversion="release-$1"
fi

echo "Updating to version: $nversion"

sudo nix-channel --add "https://nixos.org/channels/nixos-$nversion" nixos
sudo nix-channel --add "https://github.com/nix-community/home-manager/archive/$hversion.tar.gz" home-manager
sudo nix-channel --add "https://nixos.org/channels/nixos-25.05" nixlegacy
sudo nix-channel --update
