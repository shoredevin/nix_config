{ config, pkgs, lib, ... }:

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
