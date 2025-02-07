{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "intel";
  };

  services = {
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
      powerKey = "ignore";
    };
    thermald.enable = true;
    tlp = {
      enable = true;
    };
  };

  preset = "personal";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  networking.interfaces.enp45s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
}
