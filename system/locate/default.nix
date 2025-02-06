{ pkgs, ... }:
let
  locate = pkgs.plocate;
in {
  environment.systemPackages = [
    locate
  ];
  services.locate = {
    package = locate;
    enable = true;
    interval = "hourly";
  };
}
