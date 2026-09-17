{ config, pkgs, lib, ... }:

{ 
  imports = [
	./hardware-configuration.nix
	../../modules/core/desktop.nix
	../../modules/apps/dev.nix
	../../modules/apps/sops-workstation.nix
	../../modules/apps/vm.nix
  ];

  modules.dev.enable = true;

  boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

boot.kernelPackages = pkgs.linuxPackages_latest;

  services.power-profiles-daemon.enable = false;
  services.tlp = {
	enable = true;

	settings = {
	  START_CHARGE_THRESH_BAT0 = 75;
	  STOP_CHARGE_THRESH_BAT0 = 80;
	};
  };
  
  environment.sessionVariables = {
    COSMIC_DISABLE_HARDWARE_CURSORS = "1";
    COSMIC_DISABLE_DIRECT_SCANOUT = "1";
  };
  boot.kernelParams = [
  "quiet"
  "loglevel=3"
  "amdgpu.backlight=0" # Prevents driver backlight re-initialization delays
"amdgpu.dcdebugmask=0x10"  # Disables DMCUB logging loops
  "amdgpu.psr=0"             # Disables Panel Self Refresh (common crash source on mobile Ryzen)
];

}
	   
