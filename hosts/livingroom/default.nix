{ config, pkgs, lib, ... }:

{ 
    imports = [
        ./hardware-configuration.nix
        ../../modules/core/desktop.nix
        ../../modules/core/auto-update.nix
        ../../users/miya/default.nix
        ../../users/senna/default.nix
    ];

	modules.auto-update = {
      enable = true;
      operation = "boot";
    };	
}
