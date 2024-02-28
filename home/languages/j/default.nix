{ pkgs, ... }:
{
  home.packages = with pkgs; [
    stable.j
  ];
}
