{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    mame
    ppsspp
    gopher6
    melonds
  ];
}
