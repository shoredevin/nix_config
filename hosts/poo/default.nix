{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix
  ];

  modules.auto-update = {
    enable = true;
    operation = "boot";
  };

  environment.systemPackages = with pkgs; [
    
  ];

  environment.sessionVariables = {
    WGPU_BACKEND = "gl"; 
  };
}
