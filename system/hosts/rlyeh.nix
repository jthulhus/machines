{ config, pkgs, ... }:
{
  my = {
    boot.mode = "uefi";
    steam = true;
    gpu = "intel";
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  preset = "personal";

  networking.interfaces.enp45s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
}
