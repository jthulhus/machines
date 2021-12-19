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
  ];

  programs.man.enable = true;
}
