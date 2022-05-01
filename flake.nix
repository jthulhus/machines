{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgsDowngrade.url = github:nixos/nixpkgs?rev=a2e281f5770247855b85d70c43454ba5bff34613;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay.url = github:nix-community/emacs-overlay;
  };

  outputs = { self, nixpkgs, homeManager, emacsOverlay, nixpkgsDowngrade, ... } @ inputs: rec {
    lib = import ./lib inputs;
    homeConfigurations = let
      inherit (homeManager.lib) homeManagerConfiguration;
      overlays = [
        emacsOverlay.overlay
        (final: prev: {
          downgrade = import nixpkgsDowngrade {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        })
      ];
    in {
      "adri@dragonbreath" = lib.mkHome {
        inherit overlays;
        hostname = "dragonbreath";
      } nixpkgs;
      "adri@cthulhu" = lib.mkHome {
        inherit overlays;
        hostname = "cthulhu";
      } nixpkgs;
    };
    nixosConfigurations = let
      beanspkgsRegistryModule = {
        nix.registry.beanspkgs = {
          from = {
            type = "indirect";
            id = "beanspkgs";
          };
          flake = nixpkgs;
        };
      };
    in with nixpkgs.lib; {
      dragonbreath = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hosts/dragonbreath.nix
          beanspkgsRegistryModule
        ];
      };
      cthulhu = nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
          ./system/hosts/cthulhu.nix
          beanspkgsRegistryModule
        ];
      };
    };
  };
}
