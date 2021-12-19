{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "window,run";
    };
  };

  home.packages = with pkgs; [
    rofi-pass
    rofi-power-menu
  ];
}
