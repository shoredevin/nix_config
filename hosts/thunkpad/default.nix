{ config, pkgs, ... }:

{ 
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

  environment.systemPackages = with pkgs; [
    btop
  ];
}
	   
