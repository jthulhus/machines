{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nm-tray
  ];
}
