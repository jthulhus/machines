{ config, pkgs, ... }:
{
  imports = [
    ../hardware-configurations/dragonbreath.nix
  ];
  
  my = {
    boot.mode = "uefi";
    steam = true;
    hostname = "dragonbreath";
    gpu = "nvidia-nouveau";
  };

  programs.sway.enable = true;

  boot.kernelParams = [
    "fbcon=rotate:3"
  ];
  
  networking.interfaces.enp4s6.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
}
