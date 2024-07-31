{ pkgs, ... }:
{
  programs.gdk-pixbuf.modulePackages = [ pkgs.libavif ];
}
