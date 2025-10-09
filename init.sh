dir=$(pwd)
if [ -f "/etc/nixos/configuration.nix" ]; then
	sudo rm /etc/nixos/configuration.nix
fi
if [ ! -f "./users/default.nix" ]; then
  	cp "./users/_example_default.nix" "./users/default.nix"
fi
sudo ln -s "$dir/configuration.nix" /etc/nixos/configuration.nix
sudo nixos-rebuild switch
