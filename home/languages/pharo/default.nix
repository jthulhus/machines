{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pharo-launcher
    pharo
  ];
}
