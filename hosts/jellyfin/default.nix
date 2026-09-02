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

  # 1. Host user and group for file permissions
  users.groups.arm = {
    gid = 1001; # Explicit GID matching container
  };

  users.users.arm = {
    isSystemUser = true;
    uid = 1001; # Explicit UID matching container
    group = "arm";
    extraGroups = [ "cdrom" ];
    home = "/home/arm";
    createHome = true;
  };

  # Allow docker users to pass unfree dependencies if needed
  nixpkgs.config.allowUnfree = true;

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

  # 2. Docker & OCI Container Management
  virtualisation.docker.enable = true;

 
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.arm-rippers = {
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    autoStart = true;
    
    ports = [
      "8080:8080"
    ];


    environment = {
      ARM_UID = "1001";
      ARM_GID = "1001";
      WEB_SERVER_IP = "0.0.0.0";
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
}
