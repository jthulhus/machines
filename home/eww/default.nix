{ pkgs, config, ... }:
let
  eww = config.programs.eww.package;
  sway = config.wayland.windowManager.sway.package;
  which-key-script = pkgs.writeShellScriptBin "which-key" ''
    function chunk() {
        ${pkgs.jq}/bin/jq -sc 'def chunk(n): range(length/n|ceil) as $i | .[n*$i:n*$i+n];'"chunk($1)" | ${pkgs.jq}/bin/jq -cs .
    }

    function parse() {
         ${pkgs.uutils-sed}/bin/sed -r 's/(.*?):\s*(.*)/{"key":"\1","description":"\2"}/'
    }

    function close() {
        # Doing `eww close which-popup` has the same effect, but if we try to close a
        # window which is not open, then `eww` complains in the logs, resulting in
        # noisy clubbering.
        if ${eww}/bin/eww active-windows | ${pkgs.ripgrep}/bin/rg which-popup; then
            ${eww}/bin/eww close which-popup
        fi
    }

    function screen() {
        ${sway}/bin/swaymsg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .output'
    }

    function open() {
        ${eww}/bin/eww open which-popup \
            --arg title="$1" \
            --arg contents="$(echo "$3" | parse | chunk $2)" \
            --screen "$(screen)"
    }

    function show_popup() {
        case "$1" in
            "default")
                close
                ;;
            "resize")
                open Resize 1 ""
                ;;
            "screenshot")
                open Screenshot 2 '
                a: choose area
                c: select active window
                w: choose window
                o: select current monitor
                '
                ;;
            "launch")
                open Launch 3 '
                b: browse files
                c: open clementine
                e: open editor
                f: open Firefox
                g: switch to games
                k: open Anki
                S-k: open Kodi
                m: switch to messaging
                s: open sound settings
                u: open Unison
                z: open Zathura
                RET: open anything
                '
                ;;
            "messaging")
                open Launch 3 '
                d: open Discord
                e: open Element
                m: open Mattermost
                s: open Signal
                t: open Thunderbird
                w: open Whatsapp
                '
                ;;
            "games")
                open Launch 3 '
                d: open Dward Fortress
                w: open Wesnoth
                m: open Minecraft
                k: open Super Tux Kart
                s: open Steam
                '
                ;;
            "power")
                open Power 2 '
                e: exit
                o: power off
                r: reboot
                l: lock screen
                '
                ;;
            "connection")
                open Wifi 1 '
                f: turn wifi off
                n: turn wifi on
                t: toggle wifi
                '
                ;;
              "notification")
                open Notification 1 '
                d: close first
                a: close all
                i: execute first
                '
                ;;
              * )
                close
                ;;
        esac
    }

    function get_binding_mode() {
         ${sway}/bin/swaymsg -t get_binding_state --raw | \
            ${pkgs.jq}/bin/jq -r '.name'
    }

    while true; do
        show_popup "$(get_binding_mode)"
        ${sway}/bin/swaymsg -t subscribe '["binding"]' >/dev/null 2>&1
    done
 '';
in {
  programs.eww = {
    enable = true;
    configDir = ./eww.d;
  };

  systemd.user.services = {
    eww = {
      Unit = {
        Description = "Widget service.";
        Documentation = "https://elkowar.github.io/eww";
        PartOf = "sway-session.target";
      };
      Service = {
        Type = "exec";
        ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
        ExecReload = "${config.programs.eww.package}/bin/eww reload";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
    which-key = {
      Unit = {
        After = "eww.service";
        PartOf = "sway-session.target";
      };
      Service = {
        Type = "exec";
        ExecStart = "${which-key-script}/bin/which-key";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "sway-session.target" ];
      };
    };
  };

  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
    inotify-tools
  ];
}
