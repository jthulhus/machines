{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "nvidia-open";
    boot.device = "/dev/nvme0n1p1";
    remote-desktop.server.enable = true;
  };

  programs.sway.enable = true;
  
  boot.kernelParams = [
    # "fbcon=rotate:3"
  ];


  fileSystems."/media" = {
    device = "/dev/disk/by-label/media";
    fsType = "ntfs";
    options = [ "users" "nofail" ];
  };
  
  preset = "personal";
  
  networking.interfaces.enp4s0.useDHCP = true;

  system.stateVersion = "25.05";
}
