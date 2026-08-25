{ pkgs, lib, ... }: {
  home.username =  "dshore";
  home.homeDirectory = "/home/dshore";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [ 
    eza 
  ];
  
  home.file.".nanorc".text = ''
    set linenumbers
    set tabsize 4
    set titlecolor white,black
    set numbercolor white,black
  '';

  programs.readline = {
    enable = true;
    variables = {
      completion-ignore-case = "on";
    };
  };

  programs.atuin = {
    enable = true;
    # enableBashIntegration = false;
    settings = {
      auto_sync = true;
      enter_accept = true;
      records = true;
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      nc = "~/Documents/nix_config/config.sh";
      nr = "~/Documents/nix_config/updateFlake.sh";
      ls = "eza --icons";
      la = "eza -a --icons";
      ll = "eza -a -l -B --icons";
      devin = "ll /etc/nixos";
      dude = "echo hello";
      nu = "~/Documents/nix_config/updateFlake.sh -u";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    baseIndex = 1;
  };

  programs.starship.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ritwickdey.liveserver
        catppuccin.catppuccin-vsc
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.startupEditor" = "none";
      };
    };
  };
}
