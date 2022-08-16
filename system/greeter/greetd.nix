{ config, lib, pkgs, ... }:
let
  sway-config = pkgs.writeText "greetd-sway-config" ''
    # `-l` activates layer-shell mode. Notica that `swaymsg exit` will be run after gtkgreet.
    exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${pkgs.sway}/bin/sway --config ${sway-config}";
    };
  };

  environment.etc."greetd/environments".text = ''
    sway
    bash
  '';
}
