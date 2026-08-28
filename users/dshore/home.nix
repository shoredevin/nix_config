{ pkgs, lib, config, ... }: {
  home.username =  "dshore";
  home.homeDirectory = "/home/dshore";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [ 
    eza 
  ];

  home.sessionPath = [
    "${config.home.homeDirectory}/Documents/nix_config/bin"
  ];
  
  home.file.".nanorc".text = ''
    set linenumbers
    set tabsize 4
    set titlecolor white,black
    set numbercolor white,black
  '';

  home.file.".config/cosmic/com.system76.CosmicBackground/v1/all".force = true;
  home.file.".config/cosmic/com.system76.CosmicBackground/v1/all".text = ''
	 (
	     output: "all",
	     source: Path("/home/dshore/Documents/nix_config/backgrounds/busan.png"),
	     filter_by_theme: true,
	     rotation_frequency: 300,
	     filter_method: Lanczos,
	     scaling_mode: Zoom,
	     sampling_method: Alphanumeric,
	 )
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
