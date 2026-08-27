{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = { 
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-legacy, home-manager, sops-nix } @inputs:
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
      ];
      
      mkHost = hostName: extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ [
          ./hosts/${hostName}/default.nix
          { networking.hostName = hostName; }
        ] ++ extraModules;
      };
    in {
      nixosConfigurations = {
        office     = mkHost "office" [ ];
        thinkpad   = mkHost "thinkpad" [ ];
        thunkpad   = mkHost "thunkpad" [ ];
        livingroom = mkHost "livingroom" [ ];
        jellyfin   = mkHost "jellyfin" [ ];
		poopbook   = mkHost "poopbook" [ ];
      };  
    };  
}
