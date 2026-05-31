{
  description = "listport's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11"; # explicitly writing 25.11????? change ltr
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, nixos-hardware, ... }:
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
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd
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
