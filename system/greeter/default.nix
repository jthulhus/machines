{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;
in {
  imports = [
    ./greetd.nix
  ];
}
