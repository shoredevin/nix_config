{ config, pkgs, lib, ... }:

{
  users.users.miya = {
    isNormalUser = true;
    description = "Miya Shore";
    extraGroups = [ "networkmanager" ];
    initialPassword = "miya";
    packages = with pkgs; [

    ];
  };
}
