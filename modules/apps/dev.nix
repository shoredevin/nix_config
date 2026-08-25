{ config, pkgs, lib, ... }:

let
  cfg = config.modules.dev;
in {
  options.modules.dev = {
    enable = lib.mkEnableOption "Dev utils";

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users who get dev utils";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.genAttrs ([ "dshore" ] ++ cfg.users) (user: {
      packages = with pkgs; [
        postgresql
        dbeaver-bin
        nodejs
        docker-compose
        postman
        androidStudioPackages.stable	 
      ];
      
      extraGroups = [ "docker" ];
    });

    virtualisation.docker.enable = true;
    
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "mydatabase" ];    
      authentication = pkgs.lib.mkOverride 10 ''
        #type    database    DBuser    origin-address	  auth-method
        local    all         all       			  		      trust
        host     all         all       127.0.0.1/32     trust
        host     all         all       ::1/128          trust
      '';
    };

    networking.firewall.allowedTCPPorts = [ 
      3000 
      3002
      4000
      5001 
    ];
    
    networking.extraHosts = ''
      127.0.0.1 tv.testinglocal.com
    '';
    
  };
}
