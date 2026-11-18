{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";

    autoGenerateKeys.enable = true;

    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };

    configurationLimit = 4;
    measuredBoot = {
      enable = true;
      pcrs = [ 4 ];
    };
  };

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
  };
}
