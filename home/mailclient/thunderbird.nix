{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    thunderbird-140
  ];
}
