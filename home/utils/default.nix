{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];
  
  home.packages = with pkgs; [
    bat
    cloc
    file
    imv
    inst
    jq
    mlocate
    musescore
    neofetch
    nix-index
    poppler_utils
    ripgrep
    tldr
    tree
    unoconv
    unzip
    vlc
  ];

  programs.man.enable = true;
}
