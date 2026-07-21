{ pkgs, ... }:
{
  home.packages = with pkgs; [
    trgui-ng
  ];
}
