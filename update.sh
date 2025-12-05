version="$1"

if [ -z "$version" ]; then
 echo "Please provide a version to update to."
 exit
fi

echo "Updating to version: $version"

sudo nix-channel --add "https://nixos.org/channels/nixos-$version" nixos
sudo nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$version.tar.gz" home-manager
sudo nix-channel --update
