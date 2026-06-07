{ pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    name = "graphite-dark";
    size = 24;
    package = pkgs.graphite-cursors;
    gtk.enable = true;
    sway.enable = true;
  };
}
