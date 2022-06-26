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
  homeModule.home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };
  pkgs = import nixpkgs { inherit system; };
in
homeManager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [
    overlaysModule
    localEntrypoint
    mainEntrypoint
    homeModule
  ];
}
