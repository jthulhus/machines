{
  self,
  nixpkgsDowngrade,
  ...
} @ inputs: {
  hostname,
  system ? "x86_64-linux",
  overlays ? [ ],
}: nixpkgs:
let
  inherit (nixpkgs.lib) nixosSystem;
  custom = {
    my.hostname = hostname;
    nixpkgs.overlays = overlays;
    nix = {
      registry = {
        beanspkgs = {
          from = {
            type = "indirect";
            id = "beanspkgs";
          };
          flake = nixpkgs;
        };
        downgrade = {
          from = {
            type = "indirect";
            id = "downgrade";
          };
          flake = nixpkgsDowngrade;
        };
      };
    };
  };
  common = "${self}/system/configuration.nix";
  entrypoint = "${self}/system/hosts/${hostname}.nix";
  hardware = "${self}/system/hardware/${hostname}.nix";
in nixosSystem {
  inherit system;
  modules = [
    common
    entrypoint
    hardware
    custom
  ];
}
