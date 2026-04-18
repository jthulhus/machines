{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-140;
    profiles.default.isDefault = true;
  };
}
