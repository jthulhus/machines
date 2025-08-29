{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "nvidia-open";
  };

  programs.sway.enable = true;
  
  boot.kernelParams = [
    # "fbcon=rotate:3"
  ];

 
  preset = "personal";
  
  networking.interfaces.enp4s0.useDHCP = true;

  system.stateVersion = "25.05";
}
