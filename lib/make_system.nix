{
  self,
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
      registry.beanspkgs = {
        from = {
          type = "indirect";
          id = "beanspkgs";
        };
        flake = nixpkgs;
      };
      binaryCachePublicKeys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      binaryCaches = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
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
