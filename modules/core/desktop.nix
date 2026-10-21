{ config, pkgs, lib, ... }:

{
  # services.xserver.enable = true;
  # services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # COSMIC Desktop
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

programs.hyprland = {
  enable = true;
  xwayland.enable = true;
};

  # Audio & Printing
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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

  services.flatpak.enable = true;

programs.hyprlock.enable = true;

  environment.systemPackages = with pkgs; [
    libreoffice
	kitty
	rofi
	quickshell
  ];

}
