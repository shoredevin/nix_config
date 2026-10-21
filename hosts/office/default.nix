{ config, pkgs, lib, ... }:

{ 
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
    ../../modules/apps/dev.nix
	../../modules/apps/gaming.nix
    ../../modules/apps/sops-workstation.nix
	../../modules/apps/vm.nix
	../../users/senna/default.nix
  ];

  modules.dev.enable = true;

  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
  
  hardware.graphics = { 
	  enable = true; 
  };

  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    
    # Software cursor fallback in case hardware cursor flickers or stays invisible
    WLR_NO_HARDWARE_CURSORS = "1";
HYPRCURSOR_ENABLED = "0";

  # NVIDIA specific Wayland fixes
  # GBM_BACKEND = "nvidia-drm";

  };

  boot.kernelParams = [
    "iommu=pt"
    "amd_iommu=off"
  ];

  environment.systemPackages = with pkgs; [
    btop
  ];

}
	   
