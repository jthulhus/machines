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
  };

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    # grub = {
    #   enable = false;
    #   efiSupport = true;
    #   useOSProber = true;
    #   # EFI support does not use this variable, so we just need to set it to a dummy value to
    #   # pass a check and allow the build.
    #   device = "nodev";
    # };
  };
}
