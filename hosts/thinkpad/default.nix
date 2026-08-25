{ config, pkgs, ... }:

{ 
    imports = [
        /etc/nixos/hardware-configuration.nix
        ../../modules/core/desktop.nix
        ../../users/miya/default.nix
        ../../users/senna/default.nix
    ];

    boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

    services.power-profiles-daemon.enable = false;
    services.tlp = {
        enable = true;
        settings = {
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            WIFI_PWR_ON_BAT = "on";
            START_CHARGE_THRESH_BAT1 = 75;            
            STOP_CHARGE_THRESH_BAT1 = 80;
        };
    };
    services.thermald.enable = true;
}
