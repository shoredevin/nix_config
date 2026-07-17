{ config, pkgs, ... }:

{
  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [ 8096 8920 47990 ];
  services.sunshine = {
    enable = true;
   	autoStart = true;
	capSysAdmin = true;
	openFirewall = true;
  };
}
