{ pkgs, ...}: {
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    brscan5 = {
      enable = true;
      netDevices = {
        home = {
          model = "DCP-1612W";
          ip = "192.168.1.10";
        };
      };
    };
    brscan4.enable = true;
  };

  services = {
    udev.packages = [ pkgs.sane-airscan ];
    ipp-usb.enable = true;
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        cups-filters
        cups-browsed
        gutenprint
        brlaser
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
