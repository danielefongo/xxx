{
  description = "A very basic flake";

  inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	home-manager = {
		url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, home-manager, ... }:
	let
		system = "x86_64-linux";
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
		lib = nixpkgs.lib;
	in {
		nixosConfigurations = {
			daniele = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
		};
		hmConfig = {
			daniele = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.${system};
				modules = [ 
					./home.nix 
					{
						home = {
							username = "daniele";
							homeDirectory = "/home/daniele";
							stateVersion = "22.11";
						};
					}
				];
			};	
		};
	};
}
