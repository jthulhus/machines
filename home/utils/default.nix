{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
    ./zotero.nix
  ];
  
  home.packages = with pkgs; [
    bat
    cloc
    elinks
    file
    imv
    isc
    jq
    musescore
    neofetch
    nix-index
    poppler_utils
    ripgrep
    tldr
    tree
    # unoconv                     # Fuck libreoffice
    unzip
    vlc
  ];

  programs.man.enable = true;
}
