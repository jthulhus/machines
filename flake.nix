{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nixpkgs-stable.url = github:nixos/nixpkgs/nixos-23.05;
    homeManager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacsOverlay = {
      url = github:nix-community/emacs-overlay;
    };
    isc = {
      url = github:jthulhu/isc;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
      nixpkgs,
      homeManager,
      emacsOverlay,
      nixpkgs-stable,
      isc,
      ...
  } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) writeShellScriptBin;
      inherit (builtins) readFile;
      isgit = writeShellScriptBin "isgit" (readFile ./scripts/isgit);
      iscPkg = isc.defaultPackage.${system};
      commonOverlays = [
        (final: prev: {
          inherit isgit;
          isc = iscPkg;
        })
      ];
    in rec {
      lib = import ./lib inputs;
      homeConfigurations = let
        overlays = [
          emacsOverlay.overlay
          (final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
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
      packages.${system}.isgit = isgit;
  };
}
