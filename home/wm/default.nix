{ pkgs, config, lib, ... }:
let
  use-sway = config.xserver == "wayland";
  inherit (lib) mkOption types;
in {
  options = {
    my.battery-device = mkOption {
      type = with types; nullOr (enum [ "BAT0" "BAT1" ]);
      description = "Which battery device to read from in the status bar.
There should be `/sys/class/power_supply/<battery-device>`.";
    };
    wm = {
      modes = mkOption {
        type = with types; attrsOf (submodule {
          help-only = mkOption {
            type = bool;
            default = false;
            example = true;
            description = "Whether to show the which-key popup for this mode only when help is enabled.";
          };
          col-size = mkOption {
            type = ints.positive;
            default = 1;
            description = "The number of keybindings per column.";
          };
          bindings = listOf (submodule {
            key = mkOption {
              type = submodule {
                key = mkOption {
                  type = string;
                };
                shift = mkOption {
                  type = bool;
                  default = false;
                  example = true;
                  description = "Add the shift key modifier to the key binding.";
                };
                windows = mkOption {
                  type = bool;
                  default = false;
                  example = true;
                  description = "Add the windows key modifier to the key binding.";
                };
              };
            };
            kind = mkOption {
              type = enum [ "raw" "mode" "open" ];
              default = "raw";
              description = 3;
            };
            description = mkOption {
              type = string;
              description = 3;
            };
            command = mkOption {
              type = nullOr string;
              default = null;
              description = 3;
            };
            enable-exec = mkOption {
              type = bool;
              default = true;
              example = false;
              description = "Whether to include this key binding in Sway config.";
            };
            enable-which = mkOption {
              type = bool;
              default = true;
              example = false;
              description = "Whether to add this key binding to the which-key popup.";
            };
          });
        });
        default = [];
        description = "Sway modes, grouping key bindings.";
      };
      lock-when-idle = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = "Whether to lock the screen after being idle for long enough.";
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Host-specific window manager configuration.";
      };
      input-event = mkOption {
        type = with types; str;
        description = "The keyboard input event path.";
      };
      bar = {
        theme = mkOption {
          type = types.enum [ "solarized-dark" ];
          default = "solarized-dark";
          description = "The bar theme";
        };
        blocks =
          let
            inherit (builtins) genList length elemAt;
            inherit (lib.attrsets) listToAttrs;
            generateBlock = name: position: {
              inherit name;
              value = {
                enable = mkOption {
                  type = types.bool;
                  default = true;
                  description = "Enable the ${name} block.";
                };
                source = mkOption {
                  type = types.path;
                  default = ./i3status-rs.d + "/${name}.toml";
                  description = "Source file for the ${name} block.";
                };
                position = mkOption {
                  type = types.int;
                  default = position;
                  description = "Position of the ${name} block.";
                };
              };
            };
            makeBlocks = blocks: genList (n: generateBlock (elemAt blocks n) (n * 10)) (length blocks);
            blocks = [
              "focused_window"
              "net"
              "sound"
              "backlight"
              "battery"
              "cpu"
              "gpu"
              "time"
              "date"
            ];
          in
          listToAttrs (makeBlocks blocks);
      };
    };
  };

  imports = [
    ./sway.nix
    ./i3.nix
  ];
  config =
    let
      inherit (lib.lists) sort;
      inherit (builtins) getAttr attrNames replaceStrings;
      inherit (lib) mkIf;
      inherit (config) wm;
      sortBlocks = sort (l: r: l.value.position < r.value.position);
      makeBlock = { key, value }:
        with value;
        if enable then
          let content = builtins.readFile source; in
          if key == "battery" then
            replaceStrings [ "@battery-device@" ] [ config.my.battery-device ] content
          else content
        else "";
      block-list = map (key: {
        inherit key;
        value = getAttr key wm.bar.blocks;
      }) (attrNames wm.bar.blocks);
      blocks = map makeBlock (sortBlocks block-list);
      quote = ''"'';
      theme = ''
        [theme]
        theme = ${quote}${wm.bar.theme}${quote}
        [theme.overrides]
        separator = "<span font_family='FiraCode Nerd Font'>\ue0b2</span>"
      '';
      icons = builtins.readFile ./i3status-rs.d/icons.toml;
      i3statusBar = builtins.concatStringsSep "\n" ([ icons theme ] ++ blocks);
    in {
      home.packages = with pkgs; [
        (if use-sway then swaylock-effects else i3lock)
        brightnessctl
        i3status-rust
        sway-contrib.grimshot
      ];

      xdg.configFile = {
        "i3status-rust/config.toml".text = i3statusBar;
      };

      services.swayidle = {
        enable = true;
        events = {
          before-sleep =  "${pkgs.systemd}/bin/loginctl lock-session";
          lock =  "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --grace 2 --fade-in 0.2 --inside-color=0000001c --ring-color=0000003e --line-color=00000000 --key-hl-color=ffffff80 --ring-ver-color=ffffff00 --separator-color=22222260 --inside-ver-color=ff99441c --ring-clear-color=ff994430 --inside-clear-color=ff994400 --ring-wrong-color=ffffff55 --inside-wrong-color=ffffff1c --text-ver-color=00000000 --text-wrong-color=00000000 --text-caps-lock-color=00000000 --text-clear-color=00000000 --line-clear-color=00000000 --line-wrong-color=00000000 --line-ver-color=00000000 --text-color=db3300ff";
        };
        timeouts = mkIf wm.lock-when-idle [
          { timeout = 300; command = "${pkgs.systemd}/bin/systemctl suspend"; }
        ];
      };
    };
}
