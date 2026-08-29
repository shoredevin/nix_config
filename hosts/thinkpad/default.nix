{ config, pkgs, lib, ... }:

{ 
    imports = [
        ./hardware-configuration.nix
        ../../modules/core/desktop.nix
        ../../modules/core/auto-update.nix
        ../../users/miya/default.nix
        ../../users/senna/default.nix
    ];

    boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

    boot.extraModulePackages = [ config.boot.kernelPackages.acpi_call ];
    boot.kernelModules = [ "acpi_call" "thinkpad_acpi" ];

    services.power-profiles-daemon.enable = false;
    services.tlp = {
        enable = true;
        settings = {
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            WIFI_PWR_ON_BAT = "on";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
            START_CHARGE_THRESH_BAT1 = 75;            
            STOP_CHARGE_THRESH_BAT1 = 80;
        };
    };
    services.thermald.enable = true;
}
