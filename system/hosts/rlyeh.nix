{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "intel";
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
      HandlePowerKey = "ignore";
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

  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  system.stateVersion = "24.11";
}
