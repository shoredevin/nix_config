{ config, pkgs, lib, ... }:

let
  launchWebapp = pkgs.callPackage ../../pkgs/launch-webapp/default.nix { };
  makeWebapp = pkgs.callPackage ../../pkgs/make-webapp/default.nix { };
  makeWebappGui = pkgs.callPackage ../../pkgs/make-webapp/gui.nix { inherit makeWebapp; };
  pendingUpdateNotification = pkgs.callPackage ../../pkgs/pending-update-notification/default.nix { };
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
    (pkgs.writeShellScriptBin "bootstrap-host" (builtins.readFile ../../bin/bootstrap-host.sh))
    (pkgs.writeShellScriptBin "config" (builtins.readFile ../../bin/config.sh))
	(pkgs.writeShellScriptBin "update-flake" (builtins.readFile ../../bin/update-flake.sh))
    launchWebapp
    makeWebapp
    makeWebappGui
    pendingUpdateNotification
    hello
  ];

  systemd.user.services.update-n-startup = {
    description = "Send startup notification";
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "/run/current-system/sw/bin/update-n";
    };
  };  

  systemd.user.paths.update-n-watcher = {
    description = "Watch for NixOS system profile changes";
    wantedBy = [ "graphical-session.target" ];
    pathConfig = {
      PathChanged = "/nix/var/nix/profiles/system";
      Unit = "update-n-startup.service";
    };
  };

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
