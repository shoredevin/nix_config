dir=$(pwd)
if [ -f "/etc/nixos/configuration.nix" ]; then
	sudo rm /etc/nixos/configuration.nix
fi
if [ ! -f "./users/default.nix" ]; then
  	cp "./users/_example_default.nix" "./users/default.nix"
fi
sudo ln -s "$dir/configuration.nix" /etc/nixos/configuration.nix

nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update

sudo nixos-rebuild switch

git clone https://github.com/catppuccin/cosmic-desktop.git ~/Documents/catppuccin
