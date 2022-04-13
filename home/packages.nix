{ pkgs, config, inputs, ... }:
let
  pkgsWithCalibre = inputs.nixpkgsWorkingCalibre.legacyPackages.x86_64-linux;
in {
  home.packages = with pkgs; [                        # Usual stuff
    anki-bin
    clementine
    unison
    pkgsWithCalibre.calibre
    graphviz
  ] ++ [                       # Gnome, gtk and qt utilities
    dconf
    qt5ct
  ] ++ [                        # Imagemagick
    imagemagick
    inkscape
  ] ++ [                        # Nss
    nss
  ] ++ [                        # Sane
    sane-airscan
    sane-frontends
    xsane
  ] ++ [                        # Dmenu
    (if config.xserver == "wayland" then dmenu-wayland else dmenu)
    libnotify
  ];
  
  programs = {    
    home-manager.enable = true;

    direnv.enable = true;
  };

  services = {
    unison = {
      enable = true;
    };
    lorri.enable = true;
  };
}
