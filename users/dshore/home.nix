{ pkgs, lib, ... }: {
  home.username =  "dshore";
  home.homeDirectory = "/home/dshore";
  home.stateVersion = "25.05";

  home.packages = [ pkgs.atool pkgs.httpie pkgs.eza ]; # Added eza since you use it in aliases

  home.file.".nanorc".text = ''
    set linenumbers
    set tabsize 4
    set titlecolor white,black
    set numbercolor white,black
  '';

  home.file.".inputrc".text = ''
	set completion-ignore-case On
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
    shellAliases = {
      nc = "~/Documents/nix_config/config.sh";
      nr = "~/Documents/nix_config/updateFlake.sh";
      ls = "eza --icons";
      la = "eza -a --icons";
      ll = "eza -a -l -B --icons";
      devin = "ll /etc/nixos";
      dude = "echo hello";
      nu = "~/Documents/nix_config/update.sh";
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
}
