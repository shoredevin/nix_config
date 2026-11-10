{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    mame
    ppsspp
    gopher64
    melonds
    tailscale
  ];

  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	localNetworkGameTransfers.openFirewall = true;
  };

services.tailscale.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

}
