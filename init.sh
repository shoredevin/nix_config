dir=$(pwd)

if [ -f "/etc/nixos/configuration.nix" ]; then
	sudo rm /etc/nixos/configuration.nix
fi

if [ -d "/etc/nixos/users" ]; then
	sudo rm -r "/etc/nixos/users"
fi

if [ ! -f "./users/default.nix" ]; then
  	cp "./users/_example_default.nix" "./users/default.nix"
fi

sudo ln -s "$dir/configuration.nix" /etc/nixos/configuration.nix
sudo ln -s "$dir/users" /etc/nixos


nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
nix-channel --update

sudo nixos-rebuild switch

git clone https://github.com/catppuccin/cosmic-desktop.git ~/Documents/catppuccin
