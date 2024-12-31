{
  description = "Xam's flake for NixOS and Nix-Darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      elysium = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/elysium/configuration.nix
        ];
      };

      aeneas = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/aeneas/configuration.nix
	      ];
      };
    };

    darwinConfigurations = {
      xam-mac-work = nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/xam-mac-work/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    homeConfigurations = {
      "xamcost@elysium" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };
        extraSpecialArgs.inputs = inputs;
        modules = [
           ./home-manager/hosts/elysium.nix
        ];
      };

      "mcostalonga@xam-mac-work" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-darwin";
          config = {
            allowUnfree = true;
          };
        };
        extraSpecialArgs.inputs = inputs;
        modules = [
           ./home-manager/hosts/xam-mac-work.nix
        ];
      };

      "xam@aeneas" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          config = {
            allowUnfree = true;
          };
        };
        extraSpecialArgs.inputs = inputs;
        modules = [
           ./home-manager/hosts/aeneas.nix
        ];
      };
    };
  };
}
