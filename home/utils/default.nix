{ pkgs, ... }:
{
  imports = [
    ./zathura.nix
  ];
  
  home.packages = with pkgs; [
    imv
    file
    neofetch
    bat
    tldr
    nix-index
    ripgrep
    vlc
    cloc
  ];

  programs.man.enable = true;
}
