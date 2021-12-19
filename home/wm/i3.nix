{ pkgs, config, lib, ... }:
{
  config = lib.mkIf (config.xserver == "xorg") {
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        keybindings = { };
        bars = [ ];
      };
      extraConfig = builtins.readFile ./wm-config;
    };
  };
}
