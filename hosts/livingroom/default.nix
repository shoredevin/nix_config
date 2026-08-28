{ config, pkgs, lib, ... }:

{ 
    imports = [
        ./hardware-configuration.nix
        ../../modules/core/desktop.nix
        ../../modules/core/auto-update.nix
        ../../users/miya/default.nix
        ../../users/senna/default.nix
    ];

    # nix.settings.trusted-users = [ "root" "@wheel" "dshore" ];
}
