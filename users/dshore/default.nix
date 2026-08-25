{ config, lib, pkgs, modulesPath, ... }:

{	
  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "docker" 
    ];
  };

  home-manager.users.dshore = import ./home.nix;
}
