{ pkgs, lib, config, ... }:
with lib;
{
  imports = [
    ./alacritty
    ./aseprite
    ./bash
    ./emacs
    ./file-browser
    ./firefox
    ./fonts
    ./games
    ./gammastep
    ./gimp
    ./git
    ./gpg
    ./gtk
    ./languages
    ./ldap
    ./light
    ./mailclient
    ./messaging
    ./network
    ./notifications
    ./packages.nix
    ./pass
    ./qt
    ./rofi
    ./sound
    ./sound
    ./ssh
    ./swappy
    ./utils
    ./wifi
    ./wm
    ./xdg
  ];

  options = {
    xserver = mkOption {
      type = with types; enum [ "wayland" "xorg" ];
      default = "wayland";
      description = ''
The system xserver.
This impacts some utilities (dmenu, ...) and the wm (sway or i3).
i3 is currently *not supported* meaning it *could* work out-of-the-box,
but it also could not. Not testing.
'';
    };
  };

  config = let
    inherit (builtins) elem;
    inherit (lib) getName;
    unfreePredicate = pkg: elem (getName pkg) allowedUnfree;
    allowedUnfree = [ "dwarf-fortress" "discord" "minecraft-launcher" "minecraft-server" "aseprite" ];
  in {
    nixpkgs.config.allowUnfreePredicate = unfreePredicate;
    home = {
      stateVersion = "20.09";

      file = {
        ".XCompose".source = ./xcompose;
        ".config/direnv".source = ./direnv;
      };
      
      language = let
        fr = "fr_FR.UTF-8";
        us = "en_US.UTF-8";
      in
        {
          measurement = fr;
          paper = fr;
          monetary = fr;
          time = fr;
          telephone = fr;
          address = fr;
        };
      
      sessionPath = [ "~/.local/bin" ];
      sessionVariables = {
        EDITOR = "emacs";
        XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:$XDG_DATA_DIRS";
        XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    gtkBookmarks = [
      "prog"
      "Private/d"
      "Private/d/scolarite/ens"
    ];
    
    fonts.fontconfig.enable = true;

    news.display = "silent";
  };
}
