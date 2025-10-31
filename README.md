# nix_config
This is my configuration file for NixOS

- Running init.sh will run the setup script for the Nix environment and will do the following:
	- Prompt for the hostname for the machine and create a hostname file
	- Symlink the nix config file from the current directory to /etc/nixos/
	- Symlink the users directory from the current directory to /etc/nixos/
	- Symlink the hostname file from the current directory to /etc/nixos/

- To configure users copy the _default file and manage the users as desired. Each user import will correspond with a different user and user file
