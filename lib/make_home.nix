{
  self,
  homeManager,
  ...
} @ inputs: {
  username ? "adri",
  hostname,
  system ? "x86_64-linux",
  overlays ? []
}: nixpkgs:
let
  args.inputs = inputs;
  localEntrypoint = "${self}/home/hosts/${username}@${hostname}.nix";
  mainEntrypoint = "${self}/home/home.nix";
  overlaysModule.nixpkgs.overlays = overlays;
in
homeManager.lib.homeManagerConfiguration {
  inherit username system;
  homeDirectory = "/home/${username}";
  extraModules = [
    overlaysModule
  ];
  configuration = { lib, ... }: {
    _module = {
      inherit args;
    };
    imports = [
      localEntrypoint
      mainEntrypoint
    ];
  };
}
