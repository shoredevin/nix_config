{ config, lib, pkgs, modulePath, ... }:

{
  users.users.miya = {
    isNormalUser = true;
    description = "Miya Shore";
    extraGroups = [ "networkmanager" ];
    initialPassword = "miya";
    packages = with pkgs; [
        neovim
      ];
    };
}
