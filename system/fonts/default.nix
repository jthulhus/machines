{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.fira-code
    source-code-pro
    helvetica-neue-lt-std
  ];
}
