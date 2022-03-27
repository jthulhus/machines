{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gprolog
  ];
}
