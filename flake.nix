{
  description = "Full BB configuration.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nixpkgs-stable.url = github:nixos/nixpkgs/nixos-23.05;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
    };
    isc = {
      url = github:jthulhu/isc;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lean4-mode = {
      url = github:leanprover/lean4-mode;
      flake = false;
    };
    kbd-mode = {
      url = github:kmonad/kbd-mode;
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , emacs-overlay
    , nixpkgs-stable
    , isc
    , lean4-mode
    , kbd-mode
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (pkgs) writeShellScriptBin;
      inherit (builtins) readFile;
      isgit = writeShellScriptBin "isgit" (readFile ./scripts/isgit);
      iscPkg = isc.defaultPackage.${system};
      common-overlays = [
        (final: prev: {
          inherit isgit;
          isc = iscPkg;
        })
      ];
      user-overlays = [
        emacs-overlay.overlay
        (final: prev: {
          inherit lean4-mode kbd-mode;
          stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    in
    rec {
      lib = import ./lib inputs {
        inherit user-overlays common-overlays;
        home-configurations = homeConfigurations;
        system-configurations = nixosConfigurations;
      };
      homeConfigurations =
        let
          overlays = user-overlays ++ common-overlays
          ;
        in
        {
          "adri@dragonbreath" = lib.mkHome
            {
              inherit overlays;
              hostname = "dragonbreath";
            }
            nixpkgs;
          "adri@cthulhu" = lib.mkHome
            {
              inherit overlays;
              hostname = "cthulhu";
            }
            nixpkgs;
          "adri@rlyeh" = lib.mkHome
            {
              inherit overlays;
              hostname = "rlyeh";
            }
            nixpkgs;
        };
      nixosConfigurations = {
        dragonbreath = lib.mkSystem
          {
            hostname = "dragonbreath";
            overlays = common-overlays;
          }
          nixpkgs;
        cthulhu = lib.mkSystem
          {
            hostname = "cthulhu";
            overlays = common-overlays;
          }
          nixpkgs;
        rlyeh = lib.mkSystem
          {
            hostname = "rlyeh";
            overlays = common-overlays ++ user-overlays;
          }
          nixpkgs;
      };
      packages.${system}.isgit = isgit;
    };
}
