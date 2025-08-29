{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) enum;
  inherit (config) my;
  inherit (builtins) any;
  nvidia-drivers = [ "nvidia-proprietary" "nvidia-nouveau" "nvidia-open" ];
  # Note that the `nvidia-open` driver is *also* proprietary, it just happen to be open source,
  # contrary to `nvidia-proprietary` which is closed-source
  proprietary-nvidia-drivers = [ "nvidia-proprietary" "nvidia-open" ];
  contains-driver = any (driver: my.gpu == driver);
  ifNvidiaProp = mkIf (any (driver: my.gpu == driver) nvidia-drivers);
  if-nvidia-proprietary = contains-driver proprietary-nvidia-drivers;
  extraEnv = ifNvidiaProp {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
in {
  options.my.gpu = mkOption {
    type = enum [ "nvidia-proprietary" "nvidia-nouveau" "nvidia-open" "intel" "amd" "none" ];
    example = "nvidia-nouveau";
    description = "What GPU drivers are required.";
  };
  config = {
    my.unfree = ifNvidiaProp [ "nvidia-x11" "nvidia-settings" ];
    services = {
      xserver.videoDrivers = mkIf if-nvidia-proprietary [ "nvidia" ];
    };
    hardware.graphics = {
      enable = true;
    };
    hardware.nvidia = {
      # package = ifNvidiaProp config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      open = !(my.gpu == "nvidia-proprietary");
    };
    environment = {
      variables = extraEnv;
      sessionVariables = extraEnv;
    };
  };
}
