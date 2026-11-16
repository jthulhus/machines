{ config, pkgs, lib, ... }:
{
  my = {
    steam = true;
    gpu = "nvidia-open";
    remote-desktop.server.enable = true;
  };

  programs.sway.enable = true;

  boot.kernelParams = [
    # "fbcon=rotate:3"
  ];

  fileSystems."/media" = {
    device = "/dev/disk/by-label/media";
    fsType = "ext4";
    options = [ "users" "nofail" "mode=777" ];
  };

  preset = "personal";

  networking.interfaces.enp4s0.useDHCP = true;

  programs.captive-browser.enable = lib.mkForce false;

  system.stateVersion = "25.05";
  
  services.ollama = {
    port = 11434;
    openFirewall = true;
    host = "0.0.0.0";
  };
}
