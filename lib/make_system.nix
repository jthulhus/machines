{
  self,
  ...
} @ inputs: {
  hostname,
  system ? "x86_64-linux"
}: nixpkgs:
let
  inherit (nixpkgs.lib) nixosSystem;
  beanspkgsRegistryModule = {
    nix.registry.beanspkgs = {
      from = {
        type = "indirect";
        id = "beanspkgs";
      };
      flake = nixpkgs;
    };
  };
  hostnameModule.my.hostname = hostname;
  common = "${self}/system/configuration.nix";
  entrypoint = "${self}/system/hosts/${hostname}.nix";
  hardware = "${self}/system/hardware/${hostname}.nix";
in nixosSystem {
  inherit system;
  modules = [
    common
    entrypoint
    hardware
    beanspkgsRegistryModule
    hostnameModule
  ];
}
