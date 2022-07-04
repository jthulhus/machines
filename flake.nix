{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgsDowngrade.url = github:nixos/nixpkgs?rev=a2e281f5770247855b85d70c43454ba5bff34613;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay = {
      url = github:nix-community/emacs-overlay;
    };
    inst = {
      url = github:theblackbeans/inst;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager, emacsOverlay, nixpkgsDowngrade, inst, ... } @ inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      inherit (pkgs) writeShellScriptBin;
      inherit (builtins) readFile;
      isgit = writeShellScriptBin "isgit" (readFile ./scripts/isgit);
      instPkg = inst.defaultApp.${system};
      commonOverlays = [
        (final: prev: {
          inherit isgit instPkg;
        })
      ];
    in rec {
      lib = import ./lib inputs;
      homeConfigurations = let
        overlays = [
          emacsOverlay.overlay
          (final: prev: {
            downgrade = import nixpkgsDowngrade {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          })
        ] ++ commonOverlays;
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
      nixosConfigurations = {
        dragonbreath = lib.mkSystem {
          hostname = "dragonbreath";
          overlays = commonOverlays;
        } nixpkgs;
        cthulhu = lib.mkSystem {
          hostname = "cthulhu";
          overlays = commonOverlays;
        } nixpkgs;
      };
      packages.x86_64-linux.isgit = isgit;
  };
}
