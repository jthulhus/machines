{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    settings = {
      modi = "window,run";
    };
  };

  home.packages = with pkgs; [
    tessen
    rofi-power-menu
  ];
}
