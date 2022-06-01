{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) enum str;
  inherit (config) my;
  ifUefi = mkIf (my.boot.mode == "uefi");
  ifBios = mkIf (my.boot.mode == "bios");
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
    systemd-boot.enable = ifUefi true;
    efi.canTouchEfiVariables = ifUefi true;
    grub = ifBios {
      enable = true;
      version = 2;
      device = my.boot.device;
    };
  };
}
