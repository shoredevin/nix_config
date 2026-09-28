{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    mame
    ppsspp
    gopher64
    melonds
  ];

  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	localNetworkGameTransfers.openFirewall = true;
  };
}
