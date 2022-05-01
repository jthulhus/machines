{ pkgs, inputs, ... }:
let
  pkgsWithWorkingMitScheme = inputs.nixpkgsWorkingMitScheme.legacyPackages.x86_64-linux;
in {
  home.packages = with pkgs; [
    pkgsWithWorkingMitScheme.mitscheme
    scheme-manpages
  ];
}
