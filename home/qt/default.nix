{ pkgs, ... }:
let
  accent = "Mauve";
  variant = "Mocha";
in {
  home.packages = with pkgs; [
    (catppuccin-kvantum.override {
      inherit accent variant;
    })
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-${variant}-${accent}";
  };
  
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Kvantum";
  };
}
