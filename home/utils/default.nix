{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    bat
    file
    isc
    jq
    stable.musescore
    fastfetch
    ripgrep
    trashy
    tree
    vlc
  ];
}
