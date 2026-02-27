# 
{
  description = "My first flake!";

  # Essentially pointing to a bunch of git repos which we will build from
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # Allow unfree packages
    # nixpkgs.config.allowUnfree = true;
    home-manager.url = "github:nix-community/home-manager/release-25.11"; # explicitly writing 25.11????? change ltr
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Make sure versions of nixpkgs being referenced in both above are the exact same.
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
       #pkgs = nixpkgs.legacyPackages.${system};
       pkgs = import nixpkgs {
         system = system; # whatever your system name is
         config = {
            allowUnfree = true;
         };
       };
#      pkgs = import nixpkgs {
#	inherit system;
#	config.allowUnfree = true;
      #};
    in {
    nixosConfigurations.nixos = lib.nixosSystem {
      inherit system;
      modules = [
	./system/configuration.nix

	# home-manager.nixosModules.home-manager
	# {
	#   home-manager.backupFileExtension = "hm-backup";
	#   home-manager.useGlobalPkgs = true;
	#   home-manager.useUserPackages = true;
	#   home-manager.users.listport = import ./home.nix;

	#   home-manager.extraSpecialArgs = {
	#     inherit hyprland;
	#   };
	# }
      ];
    };

    homeConfigurations = {
      listport = home-manager.lib.homeManagerConfiguration {
	inherit pkgs;
	modules = [ ./home ];
	extraSpecialArgs = {
	  inherit inputs;
	};
      };
    };
  };

}
