{ pkgs, ... }:
{
  home.packages = with pkgs; [
    agda
    agdaPackages.standard-library
  ];
}
