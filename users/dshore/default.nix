{ config, pkgs, lib, ... }:

{	
  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "docker" 
    ];
	openssh.authorizedKeys.keys = [
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAa7faOAy8Js3ErdqZV2IlDrMDBtvaMWklXK0J0WNBWM"
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILxy6HvxqqOH2bQc7QcwyIQqFJdTJyL1mW5IAdqg6mMn"
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcIUFRFPCYn4sAdjL9Cp2yLm+Re97CxYJQbk0/AVrWd"
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICp/dR4f/hd1gDTCKJ4eCUvJqbDMuzh9brvgc3kYfKlS"
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLzinTEZyzErp3QyMRiEqOH2t8mqIE3DVQMYO8Ec2hD"
    ];
  };

  home-manager.users.dshore = import ./home.nix;
}
