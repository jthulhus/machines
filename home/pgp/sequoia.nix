{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sequoia-sq
  ];
}
