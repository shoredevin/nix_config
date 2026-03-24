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

  outputs = { self, nixpkgs, nixpkgs-legacy, home-manager }@inputs:
    let
      shared-modules = [
        ./configuration.nix
		./users/dshore.nix
        home-manager.nixosModules.home-manager 
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dshore = import ./home/dshore_home.nix;
        }
      ];
	  girls = [
        ./users/senna.nix
		./users/miya.nix
      ];
    in {
      nixosConfigurations = {
        office = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ [ 
            ./local/office.nix

         home-manager.nixosModules.home-manager
         {
           home-manager.useGlobalPkgs = true;
           home-manager.useUserPackages = true;
           home-manager.users.dshore = import ./home/dshore_office_home.nix;
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
      hplaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ [
          { networking.hostName = "hplaptop"; }
        ];
      };
      livingroom = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ girls ++ [
          { networking.hostName = "livingroom"; }
        ];
      };
    };  
  };  
}
