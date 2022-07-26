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
    mlocate
    musescore
    neofetch
    nix-index
    ripgrep
    tldr
    tree
    unoconv
    unzip
    vlc
  ];

  programs.man.enable = true;
}
