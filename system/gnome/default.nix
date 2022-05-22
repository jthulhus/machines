{
  programs.dconf.enable = true;
  services.gnome = {
    evolution-data-server.enable = true;
    gnome-online-accounts.enable = true;
    gnome-keyring.enable = true;
  };
}
