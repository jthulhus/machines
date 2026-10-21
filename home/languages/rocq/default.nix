{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rocq-core
  ];
}
