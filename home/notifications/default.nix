{
  # services.mako = {
  #   enable = true;
  #   anchor = "top-right";
  #   borderRadius = 5;
  #   font = "monospace 15";
  #   extraConfig = ''
  #   text-alignment=center
  #   '';
  # };
  services.dunst = {
    enable = true;
    settings = {
      global = {
        origin = "top-right";
        corner_radius = 15;
        # transparency only works for X11...
        # transparency = 10;
        progress_bar_height = 25;
        progress_bar_frame_width = 0;
        progress_bar_corner_radius = 5;
        frame_width = 0;
        padding = 12;
        horizontal_padding = 12;
        highlight= "#808080";
      };
      urgency_low = {
        background = "#222222cc";
      };
      urgency_normal = {
        background = "#222222cc";
      };
      urgency_critical = {
        background = "#332222cc";
        origin = "top-center";
        padding = 8;
        horizontal_padding = 8;
        frame_width = 10;
      };
    };
  };
}
