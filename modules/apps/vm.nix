{ config, pkgs, lib, ... }:

{
	programs.virt-manager.enable = true;
	users.groups.libvirtd.members = ["dshore"];
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;

virtualisation.libvirtd = {
  onBoot = "ignore"; 
};

# Ensure libvirtd service is not pulled into multi-user.target directly
systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
systemd.services.libvirt-guests.wantedBy = lib.mkForce [ ];
}

