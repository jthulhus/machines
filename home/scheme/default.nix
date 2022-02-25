{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mitscheme
  ];
}
