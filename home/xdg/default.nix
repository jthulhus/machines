{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
  ];

  xdg =
    let
      inherit (builtins) listToAttrs;
      support = formats: apps: listToAttrs (
        map
          (format: { name = format; value = apps; })
          formats
      );
      broadSupport = cat: formats: apps:
        support
          (
            map (format: "${cat}/${format}")
              formats
          )
          apps;
      imageSupport = broadSupport "image" [ "avif" "png" "jpeg" "gif" "webm" "svg" "tiff" ];
      textSupport = broadSupport "text" [
        "plain"
        "org"
        "css"
        "csv"
        # "html"
        "javascript"
        "english"
        "plain"
        "x-makefile"
        "x-c++hdr"
        "x-c++src"
        "x-chdr"
        "x-csrc"
        "x-haskell"
        "x-java"
        "x-moc"
        "x-ocaml"
        "x-pascal"
        "x-rust"
        "x-tcl"
        "x-tex"
        "application/x-shellscript"
        "x-c"
        "x-c++"
      ];
      emailSupport = support [
        "x-scheme-handler/mailto"
        "text/calendar"
      ];
    in
    {
      enable = true;
      mimeApps = {
        enable = true;
        associations.added = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" "calibre-ebook-viewer.pdf" ];
        }
        // imageSupport [ "imv.desktop" "sxiv.desktop" "gimp.desktop" ]
        // textSupport [ "emacsclient.desktop" "emacs.desktop" ]
        // emailSupport [ "thunderbird.desktop" ];
        defaultApplications = {
          "application/pdf" = [ "org.pwmt.zathura.desktop" ];
          "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
          "x-scheme-handler/element" = [ "element.desktop" ];
          "text/html" = [ "firefox.desktop " ];
        }
        // imageSupport [ "imv.desktop" ]
        // textSupport [ "emacsclient.desktop" ]
        // emailSupport [ "thunderbird.desktop" ];
      };
    };
}
