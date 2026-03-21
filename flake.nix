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
        home-manager.nixosModules.home-manager 
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dshore = import ./users/dshore_home.nix;
        }
      ];
    in {
      nixosConfigurations = {
        office = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = shared-modules ++ [ 
            ./local/office.nix
			      ./users/dshore.nix
            { networking.hostName = "office"; }
          ];
        };
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ [
          ./users/dshore.nix
          ./users/senna.nix
          ./users/miya.nix
          { networking.hostName = "thinkpad"; }
        ];
      };
      hplaptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ [
          ./users/dshore.nix
          { networking.hostName = "hplaptop"; }
        ];
      };
      livingroom = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = shared-modules ++ [
          ./users/dshore.nix
          { networking.hostName = "livingroom"; }
        ];
      };
    };  
  };  
}
