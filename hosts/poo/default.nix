{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix
  ];


  environment.systemPackages = with pkgs; [
    btop
  ];

  environment.sessionVariables = {
    WGPU_BACKEND = "gl"; 
  };
}
