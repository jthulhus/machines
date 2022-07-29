{ config, lib, pkgs, ... }:
let
  inherit (lib) types mkOption;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (builtins) concatStringsSep;
  inherit (pkgs.gnome) adwaita-icon-theme;
  mkPath = bookmark: "file://${config.home.homeDirectory}/${bookmark}";
  gtkConfig = {
    bookmarks = map mkPath config.gtkBookmarks;
    extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = "appmenu:none";
    };
  };
  gtkConfigSourceLines = mapAttrsToList
    (key: value: "${key} = ${toString value}")
    gtkConfig.extraConfig;
  gtkConfigSource = concatStringsSep "\n" gtkConfigSourceLines;
in {
  options = {
    gtkBookmarks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Gtk bookmarks.";
    };
  };
  config = {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita-dark";
        package = adwaita-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
      };
      gtk3 = gtkConfig;
      gtk4.extraConfig = gtkConfig.extraConfig;
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
