{ pkgs, config, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
in {
  options.my.remote-desktop = {
    client.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable remote desktop server.";
      example = "true";
    };
  };
  config = {
    home.packages = mkIf config.my.remote-desktop.client.enable (with pkgs; [
      rustdesk-flutter
    ]);
  };
}
