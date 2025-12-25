{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
    ./zotero.nix
  ];
  
  home.packages = with pkgs; [
    bat
    cloc
    file
    imv
    sxiv
    isc
    jq
    stable.musescore
    neofetch
    nix-index
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
