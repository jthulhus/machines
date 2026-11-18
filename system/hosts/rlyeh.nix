{ config, pkgs, ... }:
{
  my = {
    steam = true;
    gpu = "intel";
  };

  services = {
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
      HandlePowerKey = "ignore";
    };
    thermald.enable = true;
    tlp = {
      enable = true;
    };
    ollama.environmentVariables.OLLAMA_CONTEXT_LENGTH = "45000";
  };

  preset = "personal";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  boot.plymouth.enable = false;
  boot.consoleLogLevel = 4;

  boot.kernelParams = [
    # Have logs instead of a splash image
    "systemd.show_status=true"
    "rd.systemd.show_status=true"
    # Use the modern `xe` drivers
    "i915.force_probe=!7d55"
    "xe.force_probe=7d55"
    # Disable IME drivers in stage 1 boot
    "module_blacklist=mei,mei_me,mei_hdcp,mei_pxp,mei_gsc"
  ];

  networking.interfaces.eno0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  programs.captive-browser.interface = "wlp0s20f3";

  system.stateVersion = "26.11";
}
