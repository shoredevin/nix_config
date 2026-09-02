{ config, pkgs, inputs, ... }:


let
  # Instantiate the legacy package set with system & unfree configs
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

users.users.arm = {
isNormalUser = true;
    extraGroups = [ "cdrom" "optical" ];
  };

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


# Enable Docker or Podman (Docker is used in this example)
  virtualisation.docker.enable = true;

  # Declaratively manage the ARM container
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers.arm-rippers = {
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    autoStart = true;
    ports = [
      "8080:8080"
    ];
    environment = {
      ARM_UID = "1000"; # Adjust to match host user ID if needed
      ARM_GID = "1000"; # Adjust to match host group ID if needed
	  WEB_SERVER_IP = "0.0.0.0"; # <-- Add this line
    };
    volumes = [
      "/home/arm:/home/arm"
      "/home/arm/Music:/home/arm/Music"
      "/home/arm/logs:/home/arm/logs"
      "/home/arm/media:/home/arm/media"
      "/home/arm/config:/etc/arm/config"
    ];
    devices = [
      "/dev/sr0:/dev/sr0" # Pass your optical drive mapping
    ];
    extraOptions = [
      "--privileged"
    ];
  };

systemd.services.arm = {
    description = "Automatic Ripping Machine";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "arm";
      Group = "arm";

      # Load the OMDb key as an environment variable (e.g. OMDB_API_KEY=your_key)

      # Ensure ARM has access to required binaries
      Path = with pkgs; [
        makemkv
        util-linux # Provides umount and findmnt
        curl
	pkgs-legacy.handbrake-cli
      ];
    };
  };

}
