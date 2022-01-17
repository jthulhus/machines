{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay.url = github:nix-community/emacs-overlay;
  };

  outputs = { self, nixpkgs, homeManager, emacsOverlay }: {
    homeConfigurations = let
      inherit (homeManager.lib) homeManagerConfiguration;
      overlaysModule = {
        nixpkgs.overlays = [
          emacsOverlay.overlay
        ];
      };
    in {
      "adri@dragonbreath" = homeManagerConfiguration rec {
        username = "adri";
        homeDirectory = "/home/${username}";
        configuration = ./home/home.nix;
        system = "x86_64-linux";
        extraModules = [
          ./home/hosts/dragonbreath.nix
          overlaysModule
        ];
      };
      "adri@cthulhu" = homeManagerConfiguration rec {
        username = "adri";
        homeDirectory = "/home/${username}";
        configuration = ./home/home.nix;
        system = "x86_64-linux";
        extraModules = [
          ./home/hosts/cthulhu.nix
          overlaysModule
        ];
      };
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
