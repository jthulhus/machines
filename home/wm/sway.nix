{ pkgs, config, lib, ... }:
let
  inherit (builtins) filter listToAttrs mapAttrs;
  inherit (lib) filterAttrs;
  inherit (lib.attrsets) hasAttrByPath;
  cfg = config.wm;
  mk-key = { key, windows, shift }:
    let
      w = if windows then "Mod4+" else "";
      s = if shift then "Shift+" else "";
    in "${w}${s}${key}";
  generate-bindings = { bindings, ... }: listToAttrs (map ({ key, kind, description, command, ... }: { 
    name = mk-key key; 
    value = if kind == "raw" then
      command
    else if kind == "mode" then
      ''mode "${description}"''
    else if command != null then
      ''exec "${command}", mode "default"''
    else
      throw "for key ${mk-key key} (${description}), command must not be null";
  }) (filter ({ enable-exec, ... }: enable-exec) bindings));
in {
  config = lib.mkIf (config.xserver == "wayland") {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      checkConfig = false;      # It fails to check the config due to custom layouts.
      config = {
        modifier = "Mod4";
        keybindings = 
          if hasAttrByPath [ "modes" "default" ] cfg then
            generate-bindings cfg.modes.default 
          else 
            { };
        modes = mapAttrs 
          (mode: mode-bindings: 
            generate-bindings mode-bindings // { escape = "mode \"default\""; })
          (filterAttrs (mode: _: mode != "default") cfg.modes);
        bars = [ ];
      };
      systemd.enable = true;
      extraConfig = let
        inherit (builtins) readFile replaceStrings concatStringsSep;
        baseConfig = readFile ./config;
        extraConfig = config.wm.extraConfig;
        f = replaceStrings ["@input-event@"] [config.wm.input-event];
      in concatStringsSep "\n" (map f [ baseConfig extraConfig ]);
    };
    
    home.packages = with pkgs; [
      wl-clipboard
      pango
    ];
  };
}
