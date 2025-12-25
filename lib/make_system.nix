{ self
, nixpkgs-stable
, home-manager
, ...
} @ inputs: config: { hostname
                    , system ? "x86_64-linux"
                    , overlays ? [ ]
                    ,
                    }: nixpkgs:
let
  inherit (nixpkgs.lib) nixosSystem;
  custom = {
    my.hostname = hostname;
    nixpkgs.overlays = overlays;
    nix = {
      registry = {
        jpkgs = {
          from = {
            type = "indirect";
            id = "jpkgs";
          };
          flake = nixpkgs;
        };
        stable = {
          from = {
            type = "indirect";
            id = "stable";
          };
          flake = nixpkgs-stable;
        };
      };
    };
  };
  common = "${self}/system/configuration.nix";
  entrypoint = "${self}/system/hosts/${hostname}.nix";
  hardware = "${self}/system/hardware/${hostname}.nix";
  user-module = {
    home-manager = {
      useGlobalPkgs = true;

      users.adri =
        let username = "adri"; in
        {
          imports =
            let
              local-entrypoint = "${self}/home/hosts/${username}@${hostname}.nix";
              main-entrypoint = "${self}/home/home.nix";
            in
            [
              local-entrypoint
              main-entrypoint
            ];
          config = {
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          };
        };
    };
  };
in
nixosSystem {
  inherit system;
  modules = [
    common
    entrypoint
    hardware
    custom
    home-manager.nixosModules.home-manager
    user-module
  ];
}
