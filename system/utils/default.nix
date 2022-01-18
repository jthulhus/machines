{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    emacs-nox
    xorg.xkbcomp
    git
  ];
}
