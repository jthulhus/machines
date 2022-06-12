{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openldap
  ];
}
