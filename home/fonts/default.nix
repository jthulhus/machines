{ pkgs, ... }:
{
  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    source-code-pro
    xkcd-font
  ];
}
