{ pkgs, ... }:
{
  fonts.fonts = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    source-code-pro
  ];
}
