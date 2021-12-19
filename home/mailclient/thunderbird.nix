{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    (if config.xserver == "wayland" then thunderbird-wayland else thunderbird)
  ];
}
