{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
    settings = {
      global = {
        enable_recursive_icon_lookup = true;
        origin = "top-right";
        corner_radius = 15;
        progress_bar_height = 25;
        progress_bar_frame_width = 0;
        progress_bar_corner_radius = 5;
        frame_width = 0;
        padding = 12;
        horizontal_padding = 12;
        highlight= "#808080";
      };
      urgency_low = {
        background = "#018055cc";
      };
      urgency_normal = {
        background = "#018055cc";
      };
      urgency_critical = {
        background = "#018055cc";
        origin = "top-center";
        padding = 8;
        horizontal_padding = 8;
        frame_width = 10;
      };
    };
  };
}
