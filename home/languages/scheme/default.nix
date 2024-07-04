{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mitscheme
    scheme-manpages
  ];
}
