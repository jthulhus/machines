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
    input-event = "input/event1";
  };

  wayland.windowManager.sway.extraOptions = mkIf nvidiaProprietary [ "--unsupported-gpu" ];

  wifi.enable = false;
}
