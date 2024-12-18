{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    source-code-pro
    helvetica-neue-lt-std
  ];
}
