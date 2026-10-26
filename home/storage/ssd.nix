{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nvme-cli
  ];
}
