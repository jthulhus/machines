{ pkgs, ... }:
{
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.withPackages (ps: with ps; [ joystick ]);
  };
}
