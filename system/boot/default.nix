{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) enum str;
  inherit (config) my;
  ifUefi = mkIf (my.boot.mode == "uefi");
in
{
  options.my.boot = {
    mode = mkOption {
      type = enum [ "bios" "uefi" ];
      default = "uefi";
      example = "bios";
      description = "The motherboard's boot loader.";
    };
    device = mkOption {
      type = str;
      default = "/dev/sda";
      description = "The device grub loads.";
    };
  };
  config.boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      # EFI support does not use this variable, so we just need to set it to a dummy value to
      # pass a check and allow the build.
      device = "nodev";
    };
  };
}
