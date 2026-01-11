{ pkgs, ...}: {
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    brscan5.enable = true;
    brscan4.enable = true;
  };

  services.udev.packages = [ pkgs.sane-airscan ];
}
