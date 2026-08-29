{ config, pkgs, lib, ... }:

{
  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    grub.enable = false;
    efi.canTouchEfiVariables = true;
  };
}
