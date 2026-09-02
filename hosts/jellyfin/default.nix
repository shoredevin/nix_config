{ config, pkgs, ... }:

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
      "--restart=always"
    ];
  };

}
