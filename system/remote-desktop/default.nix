{ config, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
in {
  options.my.remote-desktop = {
    server.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable remote desktop server.";
      example = "true";
    };
  };
  config = {
    services.rustdesk-server = mkIf config.my.remote-desktop.server.enable {
      enable = true;
      openFirewall = true;
      relay.enable = false;
      signal.enable = false;
    };
  };
}
