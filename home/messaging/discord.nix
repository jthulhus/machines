{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stable.discord
  ];
}
