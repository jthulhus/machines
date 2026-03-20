{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    emacs-nox
    xkbcomp
  ];
}
