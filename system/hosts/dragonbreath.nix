{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "nvidia-proprietary";
  };

  programs.sway.enable = true;
  
  boot.kernelParams = [
    # "fbcon=rotate:3"
  ];

  greeter.wm.extraOptions = ''
    output DVI-D-1 transform 270
    output DVI-D-1 resolution 1050x1680 position 0,0
    output DP-3 resolution 1680x1050 position 1050,0
  '';
  
  preset = "personal";
  
  networking.interfaces.enp5s6.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  system.stateVersion = "20.09";
}
