{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) bool;
  inherit (config) my;
in {
  options.my.virt = mkOption {
    type = bool;
    default = false;
    example = "true";
    description = "Whether to ship virtualisation tools and libraries";
  };
  
  config = mkIf my.virt {
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
    ];
  };
}
