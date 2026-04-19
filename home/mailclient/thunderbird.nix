{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-140;
    profiles.default = {
      isDefault = true;
      extensions = [];
      settings = {
        # Automatically enable add-ons.
        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}
