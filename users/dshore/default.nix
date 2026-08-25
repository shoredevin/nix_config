{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # <home-manager/nixos>
  ];

  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "docker" 
    ];
  };
}
