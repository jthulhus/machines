{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    vdhcoapp
  ];
  
  programs.firefox = {
    enable = true;
    # /!\ Need NUR before proceeding.
    # Also, `texzilla`, `video-download-helper` and `xkcd-explainer`
    # do not exist yet.
    # extensions = with pkgs.nur.rycee.firefox-addons; [
    #   browserpass
    #   bypass-paywalls-clean
    #   clearurls
    #   https-everywhere
    #   linkhints
    #   localcdn
    #   privacy-badger
    #   rust-search-extension
    #   ublock-origin
      
    #   texzilla
    #   video-download-helper
    #   xkcd-explainer
    # ] ++ [                      # Dictionaries
    #   french-dictionary
    # ];
    package = if config.xserver == "wayland" then pkgs.firefox-wayland else pkgs.firefox;
    profiles.bbeans = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
      };
      path = "gma7ov4g.default";
    };
  };
}
