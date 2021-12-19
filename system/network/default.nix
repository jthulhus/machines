{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    networkmanager
  ];
  networking.networkmanager.enable = true;
}
