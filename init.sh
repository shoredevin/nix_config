dir=$(pwd)

# check if hostname file exists and if not create it
if [ ! -f "./hostname.nix" ]; then
	   fileContents="{ config, lib, pkgs, modulesPath, ... }:

	   {
   		   networking.hostName = __hostname;
	   }"
	   replaceString="__hostname"
	   # newString="\"test\""
	   read -p "Enter hostname: " hostname
	   newFileContents=$(echo "$fileContents" | sed "s/$replaceString/\"$hostname\"/")
	   echo "$newFileContents" > hostname.nix
fi

if [ -f "/etc/nixos/configuration.nix" ]; then
	sudo rm /etc/nixos/configuration.nix
fi

if [ -d "/etc/nixos/users" ]; then
	sudo rm -r "/etc/nixos/users"
fi

if [ -f "/etc/nixos/hostname.nix" ]; then
	sudo rm /etc/nixos/hostname.nix
fi

if [ ! -f "./users/default.nix" ]; then
  	cp "./users/_example_default.nix" "./users/default.nix"
fi

sudo ln -s "$dir/configuration.nix" /etc/nixos/configuration.nix
sudo ln -s "$dir/users" /etc/nixos
sudo ln -s "$dir/hostname.nix" /etc/nixos

sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
sudo nix-channel --update

sudo nixos-rebuild switch

if [ -d "~/Documents/catpuccin" ]; then
	git clone https://github.com/catppuccin/cosmic-desktop.git ~/Documents/catppuccin
fi
