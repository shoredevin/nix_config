{ config, pkgs, lib, ... }:

{
	programs.virt-manager.enable = true;
	users.groups.libvirtd.members = ["dshore"];
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;

}

