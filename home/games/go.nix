{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnugo
    kigo
  ];
}
