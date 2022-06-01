{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
  inherit (config) my;
in {
  options.my.steam = mkOption {
    type = bool;
    default = false;
    example = "true";
    description = "Whether to enable steam.";
  };
  config = {
    programs.steam.enable = my.steam;
    my.unfree = [ "steam" "steam-runtime" "steam-original" ];
  };
}
