{ config, pkgs, ... }:

{ 
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
    ../../modules/apps/dev.nix
  ];

  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
  hardware.graphics = { 
	enable = true; 
	extraPackages = with pkgs; [
	  intel-media-driver
    ];
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
  };

  environment.systemPackages = with pkgs; [
    btop
  ];
}
	   
