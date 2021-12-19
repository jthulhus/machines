{ pkgs, config, lib, ... }:
let
  inherit (lib) mkOption types optional;
in {
  options.games.wesnoth = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = with config; {
    home.packages = optional games.wesnoth.enable pkgs.wesnoth;
  };
} 
