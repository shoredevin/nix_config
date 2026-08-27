{ config, pkgs, lib, ... }:

{ 
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
	../../modules/core/auto-update.nix 
    ../../modules/apps/dev.nix
    ../../modules/apps/sops-workstation.nix
	../../modules/apps/vm.nix
  ];

  modules.dev.enable = true;

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
	   
