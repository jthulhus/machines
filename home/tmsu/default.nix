{ pkgs, ... }:
{
  home.packages = with pkgs; [
    tmsu
  ];
}
