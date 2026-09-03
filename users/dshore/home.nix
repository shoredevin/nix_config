{ pkgs, lib, config, ... }:

{
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

  home.file.".config/fastfetch/config.jsonc".text = ''
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
  "modules": [
    "title",
    "separator",
    "os",
    "host",
    "kernel",
    "uptime",
    "shell",
    "display",
    "de",
    "wm",
    "wmtheme",
    "theme",
    "icons",
    "font",
    "cursor",
    "terminal",
    "terminalfont",
    "cpu",
    "gpu",
    "memory",
    "swap",
    "disk",
    "localip",
    "battery",
    "poweradapter",
    "locale",
    "break",
    "colors"
  ]
}
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
	  bh = "bootstrap-host";
      nc = "config";
      nr = "update-flake";
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


	xdg.configFile."cosmic/com.system76.CosmicSettings.WindowRules/v1/tiling_exception_custom".text = ''
	  [
	      (
	          enabled: true,
	          appid: "make-webapp-dialog",
	          title: "Make Web App",
	      ),
	  ]
	'';


}
