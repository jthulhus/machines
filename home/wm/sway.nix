{ pkgs, config, lib, ... }:
{
  config = lib.mkIf (config.xserver == "wayland") {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      checkConfig = false;      # It fails to check the config due to custom layouts.
      config = {
        keybindings = { };
        bars = [ ];
      };
      extraConfig = let
        inherit (builtins) readFile replaceStrings concatStringsSep;
        baseConfig = readFile ./config;
        extraConfig = config.wm.extraConfig;
        f = replaceStrings ["@input-event@"] [config.wm.input-event];
      in concatStringsSep "\n" (map f [ baseConfig extraConfig ]);
    };
    
    home.packages = with pkgs; [
      wl-clipboard
      swayidle
      pango
    ];
  };
}
