{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (beets.override {
      pluginOverrides = {
        chroma.enable = true;
      };
    })
  ];
}
