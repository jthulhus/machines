{ config, lib, pkgs, ... }:
{
  options = let
    inherit (lib) mkOption types;
  in {
    greeter.wm.extraOptions = mkOption {
      type = with types; lines;
      default = "";
      description = "Extra options for the WM that handles the greeter.";
    };
  };
  config = let
    sway-config = pkgs.writeText "greetd-sway-config" (''
      # `-l` activates layer-shell mode. Notice that `swaymsg exit` will be run after gtkgreet.
      input type:keyboard {
        xkb_layout bsk
      }

      set $gnome-schema 'org.gnome.desktop.interface'

      exec {
        ${pkgs.glib}/bin/gsettings set $gnome-schema gtk-theme 'Adwaita-Dark'
        ${pkgs.glib}/bin/gsettings set $gnome-schema icon-theme 'Adwaita-Dark'
      }
    '' + "\n" + config.greeter.wm.extraOptions + "\n" + ''
      exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -c sway; swaymsg exit"
    '');
  in {
    services.greetd = {
      enable = false;           # Turns out this isn't very handy...
      settings = {
        default_session = {
          command = "sway --config ${sway-config}";
          user = "adri";
        };
      };
    };
    environment.etc."greetd/environments".text = ''
      sway
      bash
    '';
  };
}
