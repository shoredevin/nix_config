{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix
  ];

environment.sessionVariables = {
  WGPU_BACKEND = "gl"; 
};

  nix.settings.trusted-users = [ "root" "@wheel" "dshore" ];
}
