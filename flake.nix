{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = { 
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-legacy, home-manager } @inputs:
    let
      shared-modules = [
        ./configuration.nix
		    ./users/dshore/default.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dshore = import ./users/dshore/home.nix;
        }
      ];
	  girls = [
      ./users/senna/default.nix
		  ./users/miya/default.nix
    ];
    in {
      nixosConfigurations = {

        office = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ [ 
            ./hosts/office/default.nix
			      home-manager.nixosModules.home-manager {
	            home-manager.useGlobalPkgs = true;
	            home-manager.useUserPackages = true;
	            home-manager.users.dshore = import ./users/dshore/office_home.nix;
	          }
			      { networking.hostName = "office"; }
          ];
        };
      	
        thinkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ girls ++ [
            { networking.hostName = "thinkpad"; }
          ];
        };
        
        thunkpad = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ [
			.host/thunkpad/default.nix
            { networking.hostName = "hplaptop"; }
          ];
        };
  		  
        livingroom = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ girls ++ [
            { networking.hostName = "livingroom"; }
          ];
        };
        
        jellyfin = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ [
          ./hosts/jellyfin/default.nix
            { networking.hostName = "jellyfin"; }
          ];
        };
      };  
    };  
}
