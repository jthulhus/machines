{ pkgs, ... }:
{
  home.packages = with pkgs; [
    downgrade.mitscheme
    scheme-manpages
  ];
}
