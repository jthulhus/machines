{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # Usual stuff
    clementine
    unison
    calibre
    graphviz
  ] ++ [
    # Gnome, gtk and qt utilities
    dconf
    libsForQt5.qt5ct
  ] ++ [
    # Imagemagick
    imagemagick
    ffmpeg
    vid-stab
    inkscape
  ] ++ [
    # Nss
    nss
  ] ++ [
    # Sane
    sane-airscan
    sane-frontends
    xsane
  ] ++ [
    # Dmenu
    (if config.xserver == "wayland" then dmenu-wayland else dmenu)
    libnotify
  ] ++ [
    pdfpc
  ];

  programs = {
    home-manager.enable = true;
  };

  services = {
    unison = {
      enable = true;
    };
  };
}
