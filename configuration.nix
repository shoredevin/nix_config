# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  fonts.packages = [ pkgs.nerd-fonts.droid-sans-mono ];

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
      /etc/nixos/users
      /etc/nixos/hostname.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  # boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";  
 
  # boot.loader.systemd-boot.enable = true;  
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  nixpkgs.config.allowUnfree = true;
    
  home-manager.users.dshore = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    home.stateVersion = "25.05";
    home.file.".nanorc".text = "
	set linenumbers
        set tabsize 4
        set titlecolor white,black
        set numbercolor white,black
    ";
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
      ";
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
      };
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "mydatabase" ];    
    authentication = pkgs.lib.mkOverride 10 ''
	#type    database    DBuser    origin-address	  auth-method
        local    all         all       			  trust
	host     all         all       127.0.0.1/32       trust
	host     all         all       ::1/128            trust
    '';
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.steam.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = "

    ";
  };

  # Allow unfree packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nodejs
    pgadmin
    lutris
    wineWowPackages.waylandFull
    electricsheep
    koboldcpp
    uwsm
    chromium
    # vscode
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 
	3000 
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
  system.stateVersion = "25.05"; # Did you read the comment?

}
