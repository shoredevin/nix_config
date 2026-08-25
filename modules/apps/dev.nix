{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    postgresql
    dbeaver-bin
    nodejs
    docker-compose
    postman
    androidStudioPackages.stable	 
  ];
  
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
}