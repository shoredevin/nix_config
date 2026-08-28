{ config, pkgs, lib, ... }:

{
  sops.secrets.ntfy_env = {
    mode = "0400";
    owner = "root";
  };
 
  system.autoUpgrade = {
    enable = true;
    dates = "00:00";
    persistent = true; # Runs missed updates immediately on boot if offline at 03:00
    randomizedDelaySec = "30min";
	flake = "github:shoredevin/nix_config";
    operation = "boot";
  };

  systemd.services.nixos-upgrade = {
    onFailure = [ "notify-ntfy-failure.service" ]; 

    serviceConfig = {
      # Load credentials into service
	  EnvironmentFile = config.sops.secrets.ntfy_env.path;
     
      ExecStartPost = pkgs.writeShellScript "ntfy-success-hook" ''
        ${pkgs.curl}/bin/curl -s \
          -H "''$NTFY_AUTH_HEADER" \
          -H "Title: NixOS Update Ready" \
          -H "Priority: default" \
          -d "A new configuration has been prepared for ${config.networking.hostName}. It will apply on the next reboot." \
          https://ntfy.poketools.info/nix-update
      '';
    };
  };

  systemd.services.notify-ntfy-failure = {
    description = "Alert admin of failed NixOS upgrade via authenticated ntfy";
    
    serviceConfig = {
      Type = "oneshot";
      EnvironmentFile = config.sops.secrets.ntfy_env.path;
	};

    script = ''
      ${pkgs.curl}/bin/curl -s \
        -H "''$NTFY_AUTH_HEADER" \
        -H "Title: NixOS Upgrade FAILED" \
        -H "Priority: high" \
        -d "Background upgrade failed on ${config.networking.hostName}. Check 'journalctl -u nixos-upgrade'." \
        https://ntfy.poketools.info/nix-update
    '';
  };
}
