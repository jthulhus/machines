{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
in {
  imports = [
    ./pulseaudio.nix
  ];

  options.my.audio = mkOption {
    type = bool;
    default = false;
    example = "true";
    description = "Whether to enable sound support.";
  };
}
