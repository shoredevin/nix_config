dir=$(pwd)
if [ -f "/etc/nixos/configuration.nix" ]; then
	sudo rm /etc/nixos/configuration.nix
fi
sudo ln -s "$dir/configuration.nix" /etc/nixos/configuration.nix
sudo nixos-rebuild switch
