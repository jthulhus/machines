{ lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) bool;
  inherit (config) my;
in {
  options.my.gitea = mkOption {
    type = bool;
    default = false;
    example = "true";
    description = "Whether to enable gitea";
  };

  config = mkIf my.gitea {
    services.gitea = {
      enable = true;
      disableRegistration = true;
    };
  };
}
