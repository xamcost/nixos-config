{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
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
