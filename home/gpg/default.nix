{
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    extraConfig = "no-allow-external-cache";
  };
}
