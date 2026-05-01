{
  xserver = "wayland";
  wm = {
    bar.blocks = {
      battery.enable = false;
      gpu.enable = true;
      backlight.enable = false;
    };
    input-event = "input/event1";
    lock-when-idle = false;
  };
  
  wayland.windowManager.sway.extraOptions = [ "--unsupported-gpu" ];
  
  wifi.enable = false;
}
