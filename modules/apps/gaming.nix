{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    mame
    ppsspp
    gopher6
    melonds
  ];
}