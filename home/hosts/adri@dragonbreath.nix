{
  xserver = "wayland";
  wm = {
    bar.blocks = {
      battery.enable = false;
      # With NVidia proprietary drivers, this should be ok
      gpu.enable = true;       
      backlight.enable = false;
    };
    extraConfig = ''
output * transform 270
output DVI-D-1 resolution 1050x1680 position 0,0
output DP-1 resolution 1050x1680 position 1050,0
'';
  };

  wayland.windowManager.sway.extraOptions = [ "--unsupported-gpu" ];
  
  wifi.enable = false;
}
