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
  
  networking.interfaces.wlo1.useDHCP = true;
}
