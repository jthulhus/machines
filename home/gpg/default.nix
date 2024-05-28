{
  programs.gpg = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    extraConfig = "no-allow-external-cache";
  };
}
