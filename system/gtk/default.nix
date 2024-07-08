{ pkgs, ... }:
{
  services.xserver.gdk-pixbuf.modulePackages = [ pkgs.libavif ];
}
