# Set host arm user UID/GID to 1000 to match ARM container default
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
