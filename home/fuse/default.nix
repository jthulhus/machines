{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fuseiso
  ];
}
