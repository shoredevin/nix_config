{ config, pkgs, lib, ... }:

{
  # Declaratively ensure /root/.ssh exists on boot for bind mounts
  systemd.tmpfiles.rules = [
    "d /root/.ssh 0700 root root - -"
  ];

  system.autoUpgrade = {
    enable = true;
    dates = "minutely";
    persistent = true; # Runs missed updates immediately on boot if offline at 03:00
    # randomizedDelaySec = "45min";
    flake = "git+ssh://git@github.com/shoredevin/nix_config.git";
    operation = "boot";
  };

  systemd.services.nixos-upgrade = {
    onFailure = [ "notify-ntfy-failure.service" ]; 

    serviceConfig = {
      # Load credentials into service
      EnvironmentFile = "/etc/nixos/ntfy-auth.env";
      
      BindReadOnlyPaths = [
        "/home/dshore/.ssh:/root/.ssh"
      ];

      Environment = [
        "GIT_SSH_COMMAND=${pkgs.openssh}/bin/ssh -o StrictHostKeyChecking=accept-new"
      ];
      
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
      EnvironmentFile = "/etc/nixos/ntfy-auth.env";
    };

    script = ''
      ${pkgs.curl}/bin/curl -s \
        -H "$NTFY_AUTH_HEADER" \
        -H "Title: NixOS Upgrade FAILED" \
        -H "Priority: high" \
        -d "Background upgrade failed on ${config.networking.hostName}. Check 'journalctl -u nixos-upgrade'." \
        https://ntfy.poketools.info/nix-update
    '';
  };
}
