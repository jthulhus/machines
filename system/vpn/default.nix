{ pkgs, ... }:
let
  inherit (builtins) readFile replaceStrings;
  inherit (pkgs.irif-vpn) config cert;
in {
  services.openvpn = {
    servers = {
      irif = {
        config = replaceStrings ["ca.crt"] [(toString cert)] (readFile config);
        autoStart = false;
      };
    };
  };
  boot.kernelModules = [ "ovpn" ];
}
