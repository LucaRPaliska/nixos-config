{
  description = "listport's NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, nixos-hardware, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {

    # ── NixOS system configurations ─────────────────────────────────────────
    #   rebuild:  sudo nixos-rebuild switch --flake ~/.dotfiles/
    #   (auto-selects config matching current hostname)

    # HP Envy — AMD CPU, AMD GPU
    nixosConfigurations.hpenvy = lib.nixosSystem {
      inherit system;
      modules = [
        ./system/configuration.nix
        ./system/hosts/hpenvy
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd
      ];
    };

    # ROG — Intel CPU, NVIDIA GTX 1080 Mobile
    nixosConfigurations.rog = lib.nixosSystem {
      inherit system;
      modules = [
        ./system/configuration.nix
        ./system/hosts/rog
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-ssd
      ];
    };

    # ── Home Manager configurations ──────────────────────────────────────────
    #   rebuild:  home-manager switch --flake ~/.dotfiles/ -b backup
    #   (auto-selects config matching current user@hostname)

    homeConfigurations = {
      "listport@hpenvy" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ./home/hosts/hpenvy.nix ];
        extraSpecialArgs = { inherit inputs; hostname = "hpenvy"; };
      };

      "listport@rog" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ./home/hosts/rog.nix ];
        extraSpecialArgs = { inherit inputs; hostname = "rog"; };
      };
    };
  };
}
