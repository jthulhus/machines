{
  xserver = "wayland";
  wm = {
    bar.blocks = {
      battery.enable = false;
      gpu.enable = false;       # nvidia-smi is not available with Nouveau
      backlight.enable = false;
    };
    extraConfig = ''
output * transform 270
output DVI-D-1 resolution 1050x1680 position 0,0
output DP-1 resolution 1050x1680 position 1050,0
'';
  };
  wifi.enable = false;
}
