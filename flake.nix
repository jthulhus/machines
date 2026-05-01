{
  description = "Full jthulhu configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
      };
    };
    isc = {
      url = "github:jthulhu/isc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extra Emacs packages
    lean4-mode = {
      url = "github:leanprover/lean4-mode";
      flake = false;
    };
    kbd-mode = {
      url = "github:kmonad/kbd-mode";
      flake = false;
    };
    typst-preview = {
      url = "github:havarddj/typst-preview.el";
      flake = false;
    };
    typst-ts-mode = {
      url = "git+https://codeberg.org/meow_king/typst-ts-mode";
      flake = false;
    };

    # VPN config
    irif-vpn-config = {
      url = "file+https://www.math.univ-paris-diderot.fr/sysadmin/_media/net/openvpn/sg.ovpn";
      flake = false;
    };
    irif-vpn-cert = {
      url = "file+https://www.math.univ-paris-diderot.fr/sysadmin/_media/net/openvpn/ca.crt";
      flake = false;
    };
  };

  outputs =
    { nixpkgs
    , emacs-overlay
    , nixpkgs-stable
    , isc
    , lean4-mode
    , kbd-mode
    , typst-preview
    , typst-ts-mode
    , irif-vpn-config
    , irif-vpn-cert
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
          irif-vpn = {
            config = irif-vpn-config;
            cert = irif-vpn-cert;
          };
        })
      ];
      user-overlays = [
        emacs-overlay.overlay
        (final: prev: {
          inherit lean4-mode kbd-mode typst-preview typst-ts-mode;
          stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          pass-wayland = prev.pass-wayland.overrideAttrs (old: {
            patches = (old.patches or []) ++ [ ./home/pass/notify.patch ];
            # The patch breaks the tests, as expected since it makes user interaction necessary
            # whenpp unlocking password.
            doInstallCheck = false;
          });
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
          "adri@alice" = lib.mkHome
	    {
	      inherit overlays;
	      hostname = "alice";
	    }
	    nixpkgs;
        };
      nixosConfigurations = {
        alice = lib.mkSystem
          {
            hostname = "alice";
            overlays = common-overlays ++ user-overlays;
          }
          nixpkgs;
        dragonbreath = lib.mkSystem
          {
            hostname = "dragonbreath";
            overlays = common-overlays ++ user-overlays;
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
