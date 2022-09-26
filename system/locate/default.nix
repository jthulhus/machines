{ pkgs, ... }:
let
  locate = pkgs.plocate;
in {
  environment.systemPackages = [
    locate
  ];
  services.locate = {
    inherit locate;
    enable = true;
  };
}
