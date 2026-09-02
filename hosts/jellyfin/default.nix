{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix
  ];

  modules.auto-update = {
	enable = true;
	operation = "switch";
  };

  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [ 8096 8920 47990 ];
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
	btop
	hello
	cowsay
  ];

}
