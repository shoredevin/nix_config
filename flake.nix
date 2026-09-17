{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-legacy.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = { 
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nix-legacy";
    };
    disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = { self, nixpkgs, nix-legacy, home-manager, sops-nix, disko } @inputs:
    let
      system = "x86_64-linux";

      shared-modules = [
        ./modules/core/common.nix
        ./modules/core/boot.nix
        ./modules/apps/firefox.nix
	./users/dshore/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	  home-manager.backupFileExtension = "backup";
        }
	sops-nix.nixosModules.sops
        disko.nixosModules.disko
      ];
      
      mkHost = { hostName, diskDevice ? "/dev/sda", extraModules ? [ ] }: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs diskDevice; };
        modules = shared-modules ++ [
          ./hosts/${hostName}/default.nix
          { networking.hostName = hostName; }
        ] ++ extraModules;
      };
    in {
      nixosConfigurations = {
        office           = mkHost { hostName = "office"; };
        thinkpad         = mkHost { hostName = "thinkpad"; };
        thunkpad         = mkHost { hostName = "thunkpad"; };
        livingroom       = mkHost { hostName = "livingroom"; };
        jellyfin         = mkHost { hostName = "jellyfin"; };
	poo              = mkHost { hostName = "poo"; };
        vm               = mkHost { hostNme = "vm"; diskDevice = "/dev/vda"; };
      };  
    };  
}
