{ config, pkgs, ... }:
{
  imports = [
    ../hardware-configurations/cthulhu.nix
  ];

  my = {
    boot.mode = "uefi";
    steam = false;
    hostname = "cthulhu";
    gpu = "intel";
  };

  programs.sway.enable = true;
  
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };
  
  networking.interfaces.wlo1.useDHCP = true;
}
