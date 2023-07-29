{ pkgs, ... }:
{
  home.packages = with pkgs; [
    font-awesome
    (nerdfonts.override {
      fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ];
    })
    source-code-pro
    xkcd-font
  ];
}
