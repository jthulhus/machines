{ pkgs, config, lib, ... }:
{
  options = let
    inherit (lib) mkOption types;
  in {
    wifi.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable wifi support.";
    };
  };
  config = let
    inherit (pkgs) writeShellScriptBin;
    inherit (builtins) readFile;
    wifiSource = readFile ./wifi.bash;
    wifiScript = writeShellScriptBin "wifi" (
      if config.wifi.enable then wifiSource else ""
    );
  in {
    home.packages = [ wifiScript ];
  };
}
