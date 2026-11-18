{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    networkmanager
  ];
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  networking.dhcpcd.enable = false;
}
