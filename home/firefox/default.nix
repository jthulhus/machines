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
    languagePacks = [ "fr" "en-GB" "it" ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "always";
      ExtensionSettings =
        let
          mk = name: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
            installation_mode = "force_installed";
          }; in {
            "browserpass@maximbaz.com" = mk "browserpass";
            "gdpr@cavi.au.dk" = mk "consent-o-matic";
            "dont-track-me-google@robwu.nl" = mk "dont-track-me-google";
            "French-GC@grammalecte.net" = mk "grammalecte-fr";
            "{6d85dea2-0fb4-4de3-9f8c-26bce9a2296}" = mk "link-cleaner";
            "linkgopher@oooninja.com" = mk "link-gopher";
            "linkhints@lydell.github.io" = mk "linkhints";
            "jid1-MnnxcxisBPnSXQ@jetpack" = mk "privacy-badger17";
            "uBlock0@raymondhill.net" = mk "ublock-origin";
            "{f209234a-76f0-4735-9920-eb62507a54cd}" = mk "unpaywall";
            "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = mk "video-downloadhelper";
            "{eb72a218-9d4f-4ce0-8d6e-ad2204767c9b}" = mk "xkcd-explainer";
          };
      Preferences =
        let
          lock = Value: {
            inherit Value;
            Status = "locked";
          };
        in {
          "extensions.pocket.enabled" = lock false;
          "browser.formfill.enable" = lock false;
          "browser.toolbars.bookmarks.visibility" = lock "always";
        };
    };
    profiles.jthulhu = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
      };
      path = "gma7ov4g.default";
    };
  };
}
