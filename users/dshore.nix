{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  users.users.dshore = {
    isNormalUser = true;
    description = "Devin Shore";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
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
    ];
  };

home-manager.users.dshore = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.stateVersion = "25.05";
    home.file.".nanorc".text = "
	set linenumbers
        set tabsize 4
        set titlecolor white,black
        set numbercolor white,black
    ";
   home.file.".tmux.conf".text = ''
	'';
    programs.atuin = {
      enable = true;
      settings = {
        auto_sync = true;
	enter_accept = true;
	records = true;
      };
    };
    programs.bash = {
      enable = true;
      bashrcExtra = "
	    alias nc='sudo nano /etc/nixos/configuration.nix'
	    alias nr='sudo nixos-rebuild switch'
	    alias ls='eza --icons'
	    alias la='eza -a --icons'
        alias ll='eza -a -l -B --icons'
   	    alias devin='ll /etc/nixos'
	    alias dude='echo hello'
	    alias nu='~/Documents/nix_config/update.sh'
      ";
    };
    programs.tmux = {
      enable = true;
      clock24 = true;
	  baseIndex = 1;
    };
    programs.starship = {
      enable = true;
    };
    nixpkgs.config.allowUnfree = true;
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ritwickdey.liveserver
	    catppuccin.catppuccin-vsc
      ];
      profiles.default.userSettings = {
		"workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.startupEditor" = "none";
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];    
    authentication = pkgs.lib.mkOverride 10 ''
	#type    database    DBuser    origin-address	  auth-method
    local    all         all       			          trust
	host     all         all       127.0.0.1/32       trust
	host     all         all       ::1/128            trust
    '';
  };

}
