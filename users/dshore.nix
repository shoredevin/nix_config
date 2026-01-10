{ config, lib, pkgs, modulesPath, ... }:

{
  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	  neovim
	  neofetch
      atuin
      git
      home-manager
      htop
      gparted
      postgresql
      dbeaver-bin
      eza
      fzf
      spotify-player
	  ranger
	  feh
      nicotine-plus
    ];
  };
}
