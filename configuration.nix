# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
   nixlegacy = import inputs.nixpkgs-legacy {
     system = "x86_64-linux";
     config.allowUnfree = true;
   };
in
{
  fonts.packages = [ pkgs.nerd-fonts.droid-sans-mono ];

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # <home-manager/nixos>
      # ./users
      # ./hostname.nix
      # ./local
    ];

  # imports = [  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
	systemd-boot.configurationLimit = 10;
	grub.enable = false;
	efi.canTouchEfiVariables = true;
    #grub = {
    #  enable = true;
    #  device = "nodev";
    #  useOSProber = true;
    #  efiSupport = true;
      # efiInstallAsRemovable = false;
    # };
    #efi.canTouchEfiVariables = true;
    #efi.efiSysMountPoint = "/boot";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  
  # services.gnome.gnome-keyring.enable = true;

  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};

  # Enable the Cosmic Desktop Enviroment.
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
};

services.printing = {
  enable = true;
  drivers = with pkgs; [
    cups-filters
    cups-browsed
  ];
};
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    # packageOverrides = pkgs: {
    #   nixlegacy = import <nixlegacy> {
    #    config = config.nixpkgs.config;
    #  };
    # };
  };
  
  # Install firefox.
  programs.firefox = {
    enable = true; 
    preferences = {
      "browser.newtabpage.activity-stream.showWeather" = true;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
      "browser.newtabpage.activity-stream.system.showSponsored" = false;
    };
  };

  programs.steam.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    lutris
    libreoffice
    vlc
    tree
    google-chrome
	nixlegacy.handbrake
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
    3000 
    3002
    4000
    5001 
  ];

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  services.flatpak.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  system.stateVersion = "25.05"; # Did you read the comment?

}
