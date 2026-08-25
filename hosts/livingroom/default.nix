{ config, pkgs, ... }:

{ 
    imports = [
        ./hardware-configuration.nix
        ../../modules/core/desktop.nix
        ../../users/miya/default.nix
        ../../users/senna/default.nix
    ];
}
