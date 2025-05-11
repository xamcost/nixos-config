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
      # url = "path:/Users/mcostalonga/Documents/code/personal/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }@inputs: {
    nixosConfigurations = {
      elysium = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/elysium/configuration.nix ];
      };

      aeneas = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/aeneas/configuration.nix ];
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

      xam-mac-m4 = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs self; };
        modules = [
          ./hosts/xam-mac-m4/configuration.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    homeConfigurations = let
      mkHomeConfig = { homeConfigName, system, homeModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
          };
          extraSpecialArgs = { inherit homeConfigName inputs; };
          modules = [ homeModule ];
        };
    in {
      "xamcost@elysium" = mkHomeConfig {
        homeConfigName = "xamcost@elysium";
        system = "x86_64-linux";
        homeModule = ./home-manager/hosts/elysium.nix;
      };
      "mcostalonga@xam-mac-work" = mkHomeConfig {
        homeConfigName = "mcostalonga@xam-mac-work";
        system = "x86_64-darwin";
        homeModule = ./home-manager/hosts/xam-mac-work.nix;
      };
      "maximecostalonga@xam-mac-m4" = mkHomeConfig {
        homeConfigName = "maximecostalonga@xam-mac-work";
        system = "aarch64-darwin";
        homeModule = ./home-manager/hosts/xam-mac-m4.nix;
      };
      "xam@aeneas" = mkHomeConfig {
        homeConfigName = "xam@aeneas";
        system = "aarch64-linux";
        homeModule = ./home-manager/hosts/aeneas.nix;
      };
    };
  };
}
