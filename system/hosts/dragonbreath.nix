{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "nvidia-proprietary";
  };

  programs.sway.enable = true;
  
  boot.kernelParams = [
    "fbcon=rotate:3"
  ];

  preset = "personal";
  
  networking.interfaces.enp4s6.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
}
