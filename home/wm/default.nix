{ pkgs, config, lib, ... }:
let
  useSway = config.xserver == "wayland";
  inherit (lib) mkOption types;
  notmuchOverlay = final: prev: {
    notmuch = prev.notmuch.overrideAttrs (old: {
      doCheck = false;
    });
  };
in {
  options = {
    my.battery-device = mkOption {
      type = with types; nullOr (enum [ "BAT0" "BAT1" ]);
      description = "Which battery device to read from in the status bar.
There should be `/sys/class/power_supply/<battery-device>`.";
    };
    wm = {
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
      inherit (builtins) getAttr attrValues attrNames replaceStrings;
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
        value = getAttr key config.wm.bar.blocks;
      }) (attrNames config.wm.bar.blocks);
      blocks = map makeBlock (sortBlocks block-list);
      quote = ''"'';
      theme = ''
        [theme]
        theme = ${quote}${config.wm.bar.theme}${quote}
        [theme.overrides]
        separator = "<span font_family='FiraCode Nerd Font'>\ue0b2</span>"
      '';
      icons = builtins.readFile ./i3status-rs.d/icons.toml;
      i3statusBar = builtins.concatStringsSep "\n" ([ icons theme ] ++ blocks);
    in {
      home.packages = with pkgs; [
        (if useSway then swaylock-effects else i3lock)
        brightnessctl
        i3status-rust
        sway-contrib.grimshot
      ];

      # nixpkgs.overlays = [
      #   notmuchOverlay
      # ];

      xdg.configFile = {
        "i3status-rust/config.toml".text = i3statusBar;
      };

      services.swayidle = {
        enable = true;
        events = {
          before-sleep =  "${pkgs.systemd}/bin/loginctl lock-session";
          lock =  "${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --grace 2 --fade-in 0.2 --inside-color=0000001c --ring-color=0000003e --line-color=00000000 --key-hl-color=ffffff80 --ring-ver-color=ffffff00 --separator-color=22222260 --inside-ver-color=ff99441c --ring-clear-color=ff994430 --inside-clear-color=ff994400 --ring-wrong-color=ffffff55 --inside-wrong-color=ffffff1c --text-ver-color=00000000 --text-wrong-color=00000000 --text-caps-lock-color=00000000 --text-clear-color=00000000 --line-clear-color=00000000 --line-wrong-color=00000000 --line-ver-color=00000000 --text-color=db3300ff";
        };
        timeouts = [
          { timeout = 300; command = "${pkgs.systemd}/bin/systemctl suspend"; }
        ];
      };
    };
}
