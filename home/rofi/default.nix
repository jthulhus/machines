{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,run";
    };
  };

  home.packages = with pkgs; [
    tessen
    rofi-power-menu
  ];
}
