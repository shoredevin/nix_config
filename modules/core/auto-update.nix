{ config, pkgs, lib, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    randomizedDelaySec = "45min";
    flake = "git+ssh://git@://github.com:shoredevin/nix_config.git";
    operation = "boot";
  };

  systemd.services.nixos-upgrade = {
    onFailure = [ "notify-ntfy-failure.service" ]; 

    serviceConfig = {
      # Load the credentials file into this systemd service safely
      EnvironmentFile = "/etc/nixos/ntfy-auth.env";
      
      Environment = [
        "HOME=/home/yourusername"
        "GIT_SSH_COMMAND=ssh -i /home/yourusername/.ssh/id_ed25519 -o UserKnownHostsFile=/home/yourusername/.ssh/known_hosts"
      ];

      ExecStartPost = pkgs.writeShellScript "ntfy-success-hook" ''
        CURRENT_HOST=$(hostname)
        
        ${pkgs.curl}/bin/curl \
          -H "$NTFY_AUTH_HEADER" \
          -H "Title: NixOS Update Ready" \
          -H "Priority: low" \
          -H "Tags: white_check_mark,computer" \
          -d "A new configuration has been prepared for $CURRENT_HOST. It will apply on the next reboot." \
          https://ntfy.poketools.info/nix-update
      '';
    };
  };

  systemd.services.notify-ntfy-failure = {
    description = "Alert admin of failed NixOS upgrade via authenticated ntfy";
    
    serviceConfig = {
      Type = "oneshot";
      # Load the exact same credentials file into the failure handler
      EnvironmentFile = "/etc/nixos/ntfy-auth.env";
    };

    script = ''
      CURRENT_HOST=$(hostname)
      
      ${pkgs.curl}/bin/curl \
        -H "$NTFY_AUTH_HEADER" \
        -H "Title: NixOS Upgrade FAILED" \
        -H "Priority: high" \
        -H "Tags: x,warning" \
        -d "Background upgrade failed on $CURRENT_HOST. Check 'journalctl -u nixos-upgrade'." \
        https://ntfy.poketools.info/nix-update
    '';
  };
}
