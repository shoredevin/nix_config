{ config, pkgs, lib, ... }:

let
makeWebapp = pkgs.writeShellApplication {
    name = "make-webapp";
    runtimeInputs = with pkgs; [
      gum curl file gnused gnugrep gtk3
    ];
    text = builtins.readFile ../../bin/make-webapp.sh;
  };
makeWebappGui = pkgs.writeScriptBin "make-webapp-gui" ''
  #!${pkgs.stdenv.shell}
  
  exec ${pkgs.foot}/bin/foot \
    -a "make-webapp-dialog" \
    -T "Make Web App" \
    -f "monospace:size=14" \
    -w "700x480" \
    -o "pad=24x20" \
    -o "colors-dark.background=1e1e2e" \
    -o "colors-dark.foreground=cdd6f4" \
    -o "colors-dark.regular0=45475a" \
    -o "colors-dark.regular1=f38ba8" \
    -o "colors-dark.regular2=a6e3a1" \
    -o "colors-dark.regular3=f9e2af" \
    -o "colors-dark.regular4=89b4fa" \
    -o "colors-dark.regular5=f5c2e7" \
    -o "colors-dark.regular6=94e2d5" \
    -o "colors-dark.regular7=bac2de" \
    -o "colors-dark.bright0=585b70" \
    -o "colors-dark.bright1=f38ba8" \
    -o "colors-dark.bright2=a6e3a1" \
    -o "colors-dark.bright3=f9e2af" \
    -o "colors-dark.bright4=89b4fa" \
    -o "colors-dark.bright5=f5c2e7" \
    -o "colors-dark.bright6=94e2d5" \
    -o "colors-dark.bright7=a6adc8" \
    -o "colors-dark.selection-foreground=cdd6f4" \
    -o "colors-dark.selection-background=45475a" \
    ${pkgs.bash}/bin/bash -c "${makeWebapp}/bin/make-webapp; echo; read -p 'Press Enter to close...'"
'';

in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "@wheel" "dshore" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    git
    neovim
    htop
    fastfetch
    tree
	cowsay
    (pkgs.writeShellScriptBin "say-hi" (builtins.readFile ../../bin/say-hi.sh))
	(pkgs.writeShellScriptBin "say-bye" (builtins.readFile ../../bin/say-bye.sh))
    (pkgs.writeShellScriptBin "say-please" (builtins.readFile ../../bin/say-please.sh))
    (pkgs.writeShellApplication { 
      name = "launch-webapp"; 
	  runtimeInputs = [ pkgs.chromium ];
      text = builtins.readFile ../../bin/launch-web-app.sh;
	})
    makeWebapp
    makeWebappGui
];
  
  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
	settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    ports = [ 22 ];
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  sops.secrets.test_key_fun = {
    mode = "0400";
    owner = "dshore"; # Make sure this matches your local username
  };
  
  fonts.packages = [ pkgs.nerd-fonts.droid-sans-mono ];

  system.stateVersion = "25.05";
}
