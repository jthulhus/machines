{ lib, pkgs, config, ... }:
let
  inherit (builtins) elem filter genList length;
  inherit (lib) throwIfNot;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) sublist;
  inherit (lib.strings) toSentenceCase concatMapStringsSep;
  inherit (config.wayland.windowManager.sway.config) modifier;
  inherit (pkgs) writeShellScriptBin;
  eww = config.programs.eww.package;
  sway = config.wayland.windowManager.sway.package;
  chunks = n: l: genList (i: sublist (i * n) n l) ((length l + n - 1) / n);
  repr-key = { key, windows, shift }:
    let
      repr-windows = if windows then "⌘-" else "";
      repr-shift = if shift then "S-" else "";
      repr-key = 
        if key == "Return" then
          "⏎"
        else if key == "tab" then
          "⇥"
        else if key == "left" then
          "←"
        else if key == "right" then
          "→"
        else if key == "up" then
          "↑"
        else if key == "down" then
          "↓"
        else if key == "space" then
          "␣"
        else 
          key;
    in "${repr-windows}${repr-shift}${repr-key}";
  mk-binding = { key, kind, description, ... }:
    if kind == "raw" then
      ''{"key": "${repr-key key}", "description": [{"text": "${description}"}]}''
    else if kind == "mode" then
      ''{"key": "${repr-key key}", "description": [{"text": "+", "class": "which-mode-pre"},{"text":"${description}", "class": "which-mode"}]}''
    else
      ''{"key": "${repr-key key}", "description": [{"text": "open", "class": "which-app-pre"}, {"text": " "}, {"text": "${description}", "class": "which-app"}]}'';
  mk-case = { help-only, mode, bindings, col-size }:
    let
      bdgs = chunks col-size (filter ({ enable-which, ...}: enable-which) bindings);
      handle-chunk = chunk: ''[${concatMapStringsSep ", " mk-binding chunk}]'';
      open-command = ''open "${toSentenceCase mode}" "$(${pkgs.uutils-coreutils-noprefix}/bin/cat <<EOF
[${concatMapStringsSep ", " handle-chunk bdgs}]
EOF
)"'';
    in if help-only then ''
        "${mode}")
            if [ "$(${eww}/bin/eww get which--show-help)" = true ]; then
                ${open-command}
            else
                close
            fi
            ;;
    '' else ''
        "${mode}")
            ${open-command}
            ;;
    '';
  toggle-help = writeShellScriptBin "toggle-help" ''
    if [ "$(${eww}/bin/eww get which--show-help)" = true ]; then
      ${eww}/bin/eww update which--show-help=false
    else
      ${eww}/bin/eww update which--show-help=true
    fi
    # Notify the which-key service that it might need to refresh the pop-up.
    ${pkgs.systemd}/bin/systemctl --user kill --signal=SIGUSR1 which-key
  '';
  which-key-script =
    writeShellScriptBin "which-key" ''
      STATE=""
      function close() {
          # Doing `eww close which-popup` has the same effect, but if we try to close a
          # window which is not open, then `eww` complains in the logs, resulting in
          # noisy clubbering.
          if ${eww}/bin/eww active-windows | ${pkgs.ripgrep}/bin/rg --quiet which-popup; then
              # eww spuriously outputs blank lines, clubbering the logs.
              ${eww}/bin/eww close which-popup >/dev/null
          fi
      }

      function screen() {
          ${sway}/bin/swaymsg -t get_workspaces | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .output'
      }

      function open() {
          ${eww}/bin/eww open which-popup \
              --arg title="$1" \
              --arg contents="$2" \
              --screen "$(screen)"
      }
 
      function show_popup() {
          case "$1" in
              ${concatMapStringsSep "\n" mk-case (mapAttrsToList (mode: args: args // { inherit mode; }) config.wm.modes)}
              * )
                  close
                  ;;
          esac
      }

      function maybe_refresh() {
          local binding_mode="$(get_binding_mode)"
          local show_help="$(${eww}/bin/eww get which--show-help)"
          local screen="$(screen)"
          local new_state="$show_help:$binding_mode:$screen"
          if [ "$new_state" != "$STATE" ]; then
              STATE="$new_state"
              show_popup "$binding_mode"
          fi
      }

      function get_binding_mode() {
           ${sway}/bin/swaymsg -t get_binding_state --raw | \
              ${pkgs.jq}/bin/jq -r '.name'
      }

      function usr1_hook() {
          maybe_refresh
      }

      trap usr1_hook USR1

      while true; do
          maybe_refresh
          ${sway}/bin/swaymsg -t subscribe '["binding"]' >/dev/null 2>&1
      done
   '';
in {
  programs.eww = {
    enable = true;
    configDir = ./eww.d;
  };

  wm.modes = {
    default = {
      help-only = true;
      col-size = 4;
      bindings = [
        {
          key = {
            windows = true;
            shift = true;
            key = "q";
          };
          description = "close window";
          command = "kill";
        }
        {
          key = {
            windows = true;
            key = "Return";
          };
          kind = "open";
          description = "Terminal";
          command = "alacritty";
        }
        {
          key = {
            windows = true;
            key = "space";
          };
          kind = "mode";
          description = "launch";
        }
        {
          key = {
            windows = true;
            key = "tab";
          };
          description = "switch to other workspace";
          command = "workspace back_and_forth";
        }
        {
          key = {
            windows = true;
            key = "<i>n</i>";
          };
          enable-exec = false;
          description = "switch to workspace <i>n</i>";
        }
        {
          key = {
            windows = true;
            key = "m";
          };
          kind = "mode";
          description = "move";
        }
        {
          key = {
            windows = true;
            key = "p";
          };
          kind = "mode";
          description = "power";
        }
        {
          key = {
            windows = true;
            shift = true;
            key = "n";
          };
          kind = "mode";
          description = "notification";
        }
        {
          key = {
            windows = true;
            key = "c";
          };
          kind = "mode";
          description = "connection";
        }
        {
          key = {
            windows = true;
            key = "w";
          };
          description = "switch to window";
          command = "exec rofi -show window, mode default";
        }
        {
          key = {
            windows = true;
            key = "n";
          };
          description = "close notification";
          command = "exec dunstctl close";
        }
      ];
    };
    screenshot = {
      col-size = 2;
      bindings = [
        {
          key.key = "a";
          description = "choose area";
          command = "exec grimshot save area - | swappy -f -, mode default";
        }
        {
          key.key = "c";
          description = "select active window";
          command = "exec grimshot save active - | swappy -f -, mode default";
        }
        {
          key.key = "w";
          description = "choose window";
          command = "exec grimshot save window - | swappy -f -, mode default";
        }
        {
          key.key = "o";
          description = "select current monitor";
          command = "exec grimshot save output - | swappy -f -, mode default";
        }
      ];
    };
    launch = {
      col-size = 3;
      bindings = [
        {
          key.key = "b";
          kind = "open";
          description = "File Browser";
          command = "nautilus";
        }
        {
          key.key = "c";
          kind = "open";
          description = "Clementine";
          command = "clementine";
        }
        {
          key.key = "e";
          kind = "open";
          description = "Editor";
          command = "emacsclient -c";
        }
        {
          key.key = "f";
          kind = "open";
          description = "Web Browser";
          command = "firefox";
        }
        {
          key.key = "g";
          kind = "mode";
          description = "games";
        }
        {
          key.key = "k";
          kind = "open";
          description = "Anki";
          command = "anki";
        }
        {
          key = {
            shift = true;
            key = "k";
          };
          kind = "open";
          description = "Kodi";
          command = "kodi";
        }
        {
          key.key = "m";
          kind = "mode";
          description = "messaging";
        }
        {
          key.key = "s";
          kind = "open";
          description = "Sound Settings";
          command = "pavucontrol";
        }
        {
          key.key = "u";
          kind = "open";
          description = "Unison";
          command = "unison";
        }
        {
          key.key = "z";
          kind = "open";
          description = "PDF Viewer";
          command = "zathura";
        }
        {
          key.key = "Return";
          kind = "open";
          description = "Launcher";
          command = "rofi -show run";
        }
      ];
    };
    messaging = {
      col-size = 3;
      bindings = [
        {
          key.key = "d";
          kind = "open";
          description = "Discord";
          command = "vesktop";
        }
        {
          key.key = "e";
          kind = "open";
          description = "Element";
          command = "element-desktop";
        }
        {
          key.key = "m";
          kind = "open";
          description = "Mattermost";
          command = "mattermost-desktop";
        }
        {
          key.key = "s";
          kind = "open";
          description = "Signal";
          command = "signal-desktop";
        }
        {
          key.key = "t";
          kind = "open";
          description = "Mail Client";
          command = "thunderbird";
        }
        {
          key.key = "w";
          kind = "open";
          description = "Whatsapp";
          command = "karere";
        }
      ];
    };
    games = {
      col-size = 2;
      bindings = [
        {
          key.key = "d";
          kind = "open";
          description = "Dwarf Fortress";
          command = "dfhack";
        }
        {
          key.key = "w";
          kind = "open";
          description = "Wesnoth";
          command = "wesnoth";
        }
        {
          key.key = "m";
          kind = "open";
          description = "Minecraft";
          command = "prismlauncher";
        }
        {
          key.key = "k";
          kind = "open";
          description = "Super Tux Kart";
          command = "supertuxkart";
        }
        {
          key.key = "s";
          kind = "open";
          description = "Steam";
          command = "steam";
        }
      ];
    };
    power = {
      col-size = 2;
      bindings = [
        {
          key.key = "e";
          description = "exit";
          command = "exit";
        }
        {
          key.key = "p";
          description = "poweroff";
          command = "exec poweroff";
        }
        {
          key.key = "r";
          description = "reboot";
          command = "exec reboot";
        }
        {
          key.key = "l";
          description = "lock screen";
          command = "mode default, exec loginctl lock-session";
        }
      ];
    };
    notification = {
      help-only = true;
      bindings = [
        {
          key.key = "d";
          description = "close first";
          command = "exec dunstctl close";
        }
        {
          key.key = "a";
          description = "close all";
          command = "exec dunstctl close-all, mode default";
        }
        {
          key.key = "i";
          description = "execute first";
          command = "exec dunstctl action 0, dunstctl close";
        }
      ];
    };
    connection = {
      bindings = [
        {
          key.key = "f";
          description = "turn wifi off";
          command = "exec wifi off, mode default";
        }
        {
          key.key = "n";
          description = "turn wifi on";
          command = "exec wifi on, mode default";
        }
        {
          key.key = "t";
          description = "toggle wifi";
          command = "exec wifi toggle, mode default";
        }
      ];
    };
    move = {
      help-only = true;
      bindings = [];
    };
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

  wayland.windowManager.sway.config = {
    keybindings = {
      "${modifier}+Shift+h" = "exec ${toggle-help}/bin/toggle-help, mode default";
    };
  };

  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
    inotify-tools
  ];
}
