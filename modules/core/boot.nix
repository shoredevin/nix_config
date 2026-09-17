{ config, pkgs, lib, ... }:

{
  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
	timeout = 0;
    systemd-boot.configurationLimit = 10;
    grub.enable = false;
    efi.canTouchEfiVariables = true;
  };
boot.initrd.systemd.enable = true;

}
