{ pkgs, config, lib, ... }:
let
  useSway = config.xserver == "wayland";
  inherit (lib) mkOption types;
  notmuchOverlay = final: prev: {
    notmuch = prev.notmuch.overrideAttrs (old: {
      doCheck = false;
    });
  };
in 
{
  options = {
    wm = {
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Host-specific window manager configuration.";
      };
      bar = {
        theme = mkOption {
          type = types.enum [ "solarized-dark" ];
          default = "solarized-dark";
          description = "The bar theme";
        };
        blocks = let
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
          makeBlocks = blocks: genList (n: generateBlock (elemAt blocks n) (n*10)) (length blocks);
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
        in listToAttrs (makeBlocks blocks);
      };
    };
  };
  
  imports = [
    ./sway.nix
    ./i3.nix
  ];
  config = let
    inherit (lib.lists) sort;
    sortBlocks = sort (l: r: l.position < r.position);
    makeBlock = { enable, source, position }: if enable then builtins.readFile source else "";
    blocks = map makeBlock (sortBlocks (builtins.attrValues config.wm.bar.blocks));
    quote = ''"'';
    theme = ''
[theme]
name = ${quote}${config.wm.bar.theme}${quote}
[theme.overrides]
separator = "<span font_family='FiraCode Nerd Font'>\ue0b2</span>"
'';
    icons = builtins.readFile ./i3status-rs.d/icons.toml;
    i3statusBar = builtins.concatStringsSep "\n" ([ icons theme ] ++ blocks);
  in
    {
      home.packages = with pkgs; [
        (if useSway then swaylock-fancy else i3lock)
        brightnessctl
        pulseaudio
        i3status-rust
        sway-contrib.grimshot
      ];

      nixpkgs.overlays = [
        notmuchOverlay
      ];
      
      xdg.configFile = {
        "i3status-rust/config.toml".text = i3statusBar;
      };
    };
}
