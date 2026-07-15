{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # <home-manager/nixos>
  ];

  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      neovim
      fastfetch
      atuin
      home-manager
      htop
      postgresql
      dbeaver-bin
      eza
      fzf
      spotify-player
	  feh
      nicotine-plus
      nodejs
      # pgadmin4
      wireshark
      docker
      docker-compose
	  mame
	  ppsspp
	  gopher64
    ];
  };
  virtualisation.docker.enable = true;
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];    
    authentication = pkgs.lib.mkOverride 10 ''
	#type    database    DBuser    origin-address	  auth-method
    local    all         all       			  		  trust
	host     all         all       127.0.0.1/32       trust
	host     all         all       ::1/128            trust
    '';
  };

}
