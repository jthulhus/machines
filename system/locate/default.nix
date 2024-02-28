{ pkgs, ... }:
let
  locate = pkgs.plocate;
in {
  environment.systemPackages = [
    locate
  ];
  services.locate = {
    package = locate;
    localuser = null;
    enable = true;
    interval = "hourly";
  };
}
