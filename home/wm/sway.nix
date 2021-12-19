{ pkgs, config, lib, ... }:
{
  config = lib.mkIf (config.xserver == "wayland") {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        keybindings = { };
        bars = [ ];
      };
      extraConfig = let
        baseConfig = builtins.readFile ./wm-config;
        extraConfig = config.wm.extraConfig;
      in builtins.concatStringsSep "\n" [ baseConfig extraConfig ];
    };
    
    home.packages = with pkgs; [
      wl-clipboard
      swayidle
      pango
    ];
  };
}
