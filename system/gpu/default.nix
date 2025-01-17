{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf;
  inherit (lib.types) enum;
  inherit (config) my;
  ifNvidiaProp = mkIf (my.gpu == "nvidia-proprietary");
  extraEnv = ifNvidiaProp {
    WLR_NO_HARDWARE_CURSORS = "1";
  };
in {
  options.my.gpu = mkOption {
    type = enum [ "nvidia-proprietary" "nvidia-nouveau" "intel" "amd" "none" ];
    example = "nvidia-nouveau";
    description = "What GPU drivers are required.";
  };
  config = {
    my.unfree = ifNvidiaProp [ "nvidia-x11" "nvidia-settings" ];
    services = {
      xserver.videoDrivers = ifNvidiaProp [ "nvidia" ];
    };
    hardware.graphics = {
      enable = true;
    };
    hardware.nvidia = {
      package = ifNvidiaProp config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      open = !(my.gpu == "nvidia-proprietary");
    };
    environment = {
      variables = extraEnv;
      sessionVariables = extraEnv;
    };
  };
}
