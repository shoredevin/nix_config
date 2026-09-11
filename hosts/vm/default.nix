{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix
  ];

  modules.auto-update = {
    enable = true;
    operation = "boot"; # Or switch this to "switch" if changes should be applied right away
  };

}
