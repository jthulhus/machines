{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgsWorkingCalibre.url = github:nixos/nixpkgs?rev=1d08ea2bd83abef174fb43cbfb8a856b8ef2ce26;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay.url = github:nix-community/emacs-overlay;
  };

  outputs = { self, nixpkgs, homeManager, emacsOverlay, ... } @ inputs: rec {
    lib = import ./lib inputs;
    homeConfigurations = let
      inherit (homeManager.lib) homeManagerConfiguration;
      overlays = [
        emacsOverlay.overlay
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
