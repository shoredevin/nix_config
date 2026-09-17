{ config, pkgs, lib, ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    timeout = 0;
    grub.enable = false;
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.systemd.enable = true;

  # Universal parameters safe for ALL hosts
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "vt.global_cursor_default=0"
  ];
}
