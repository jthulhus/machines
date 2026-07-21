{
  programs.vesktop = {
    enable = false;
    settings = {
      appBadge = false;
      arRPC = false;
      checkUpdates = false;
      minimizeToTray = false;
      tray = true;
      hardwareAcceleration = true;
      hardwareVideoAcceleration = true;
      discordBranch = "stable";
      spellCheckLanguages = [
        "fr"
        "en"
        "it"
      ];
      enableSplashScreen = false;
    };
  };
}
