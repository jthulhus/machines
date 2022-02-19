{ pkgs, config, lib, ... }:
let
  inherit (lib) mkOption types optionals;
in {
  options.games.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = with config; {
    home.packages = optionals games.minecraft.enable (with pkgs; [ minecraft minecraft-server ]);
  };
}
