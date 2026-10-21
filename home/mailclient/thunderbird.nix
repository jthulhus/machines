{
  programs.thunderbird = {
    enable = true;
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
