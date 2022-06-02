{ lib, ... }:
let
  inherit (lib) mkIf;
  nvidiaProprietary = true;
in {
  xserver = "wayland";
  wm = {
    bar.blocks = {
      battery.enable = false;
      # With NVidia proprietary drivers, this should be ok
      gpu.enable = nvidiaProprietary;
      backlight.enable = false;
    };
    extraConfig = ''
output * transform 270
output DVI-D-1 resolution 1050x1680 position 0,0
output DP-1 resolution 1050x1680 position 1050,0
'';
  };

  wayland.windowManager.sway.extraOptions = mkIf nvidiaProprietary [ "--unsupported-gpu" ];
  
  wifi.enable = false;
}
