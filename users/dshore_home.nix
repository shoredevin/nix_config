{ pkgs, ... }: {
  home.username = "dshore";
  home.homeDirectory = "/home/dshore";
  home.stateVersion = "25.05"; # Keep this as a number!

  home.packages = [ pkgs.atool pkgs.httpie pkgs.eza ]; # Added eza since you use it in aliases

  home.file.".nanorc".text = ''
    set linenumbers
    set tabsize 4
    set titlecolor white,black
    set numbercolor white,black
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
      nc = "sudo nano ~/Documents/nix_config/configuration.nix";
      nr = "sudo nixos-rebuild switch --flake ~/Documents/nix_config#office";
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
