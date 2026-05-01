{ lib, ... }:
let
  inherit (builtins) readFile;
  inherit (lib.strings) hasPrefix;
in {
  imports =
    if hasPrefix "yes" (readFile ./available) then [
      ./adri.nix
    ] else [];
}
