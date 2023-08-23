{
  xserver = "wayland";
  wm = {
    input-event = "input/event0";
    bar.blocks = {
      gpu.enable = false;
    };
  };
  my.battery-device = "BAT0";
}
