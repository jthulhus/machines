{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    bat
    tokei
    file
    imv
    sxiv
    isc
    jq
    stable.musescore
    fastfetch
    poppler-utils
    pdftk
    # zulip                       # This uses a broken version of Electron
                                  # (by which I mean brokener than Electron itself...)
    ripgrep
    tldr
    trashy
    tree
    # unoconv                     # Fuck libreoffice
    unzip
    vlc
  ];

  programs.man.enable = true;
}
