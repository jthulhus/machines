{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.my) boot;
in
{
  boot.loader = {
    systemd-boot.enable = mkIf (boot.mode == "uefi") true;
    efi.canTouchEfiVariables = mkIf (boot.mode == "uefi") true;
    grub = mkIf (boot.mode == "bios") {
      enable = true;
      version = 2;
      device = boot.device;
    };
  };
}
