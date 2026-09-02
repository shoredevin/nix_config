{ config, pkgs, inputs, ... }:

let
  pkgs-legacy = import inputs.nixpkgs-legacy {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core/desktop.nix
    ../../modules/core/auto-update.nix
  ];

  modules.auto-update = {
    enable = true;
    operation = "switch";
  };

  # Host arm user and group set to 1000 to match container defaults
  users.groups.arm = {
    gid = 1000;
  };

  users.users.arm = {
    isSystemUser = true;
    uid = 1000;
    group = "arm";
    extraGroups = [ "cdrom" ];
    home = "/home/arm";
    createHome = true;
  };

  # Services & Firewall
  services.jellyfin.enable = true;
  networking.firewall.allowedTCPPorts = [ 8080 8096 8920 47990 ];

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    hello
    cowsay
  ];

  # Docker & Declarative ARM Container
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.arm-rippers = {
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    autoStart = true;

    ports = [
      "8080:8080"
    ];

    environment = {
      ARM_UID = "1000";
      ARM_GID = "1000";
      WEB_SERVER_IP = "0.0.0.0";
      WEB_SERVER_PORT = "8080";
    };

    volumes = [
      "/home/arm:/home/arm"
      "/home/arm/Music:/home/arm/Music"
      "/home/arm/logs:/home/arm/logs"
      "/home/arm/media:/home/arm/media"
      "/home/arm/config:/etc/arm/config"
    ];

    devices = [
      "/dev/sr0:/dev/sr0"
    ];

    extraOptions = [
      "--privileged"
    ];
  };
# Automate directory creation and permissions for ARM
systemd.tmpfiles.rules = [
    "d /home/arm 0775 arm arm - -"
    "z /home/arm 0775 arm arm - -"
  ];

}
