{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stable.mitscheme
    scheme-manpages
  ];
}
