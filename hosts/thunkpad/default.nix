{ config, pkgs, ... }:

{ 
  boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

  services.power-profiles-daemon.enable = false;
	services.tlp = {
	  enable = true;

	  settings = {
	    START_CHARGE_THRESH_BAT0 = 75;
	    STOP_CHARGE_THRESH_BAT0 = 80;
	  };
	};

  environment.systemPackages = with pkgs; [
    btop
  ];
}
	   
