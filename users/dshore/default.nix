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
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB2gQThX+UZdmH1Vxkx9AB2zxDsfABvMwHY5ZJO8vt33 dshore@ED2025-013-HP-dshore"
 	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLzinTEZyzErp3QyMRiEqOH2t8mqIE3DVQMYO8Ec2hD dshore@thunkpad"
	  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICp/dR4f/hd1gDTCKJ4eCUvJqbDMuzh9brvgc3kYfKlS dshore@office"
    ];
  };

  home-manager.users.dshore = import ./home.nix;
}
