{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
  ];
  
  xdg = let
    inherit (builtins) listToAttrs;
    support = formats: apps: listToAttrs (
      map
        (format: { name = format; value = apps; })
        formats
    );
    broadSupport = cat: formats: apps:
      support (
        map (format: "${cat}/${format}")
          formats
      ) apps;
    imageSupport = broadSupport "image" [ "png" "jpeg" "gif" "svg" "tiff" ];
    textSupport = broadSupport "text" [
      "plain"
      "org"
      "css"
      "csv"
      "html"
      "javascript"
      "english"
      "plain"
      "x-makefile"
      "x-c++hdr"
      "x-c++src"
      "x-chdr"
      "x-csrc"
      "x-java"
      "x-moc"
      "x-pascal"
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
  in {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" "calibre-ebook-viewer.pdf" ];
      }
      // imageSupport [ "imv.desktop" "gimp.desktop" ]
      // textSupport [ "emacsclient.desktop" "emacs.desktop" ]
      // emailSupport [ "thunderbird.desktop" ];
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      }
      // imageSupport [ "imv.desktop" ]
      // textSupport [ "emacsclient.desktop" ]
      // emailSupport [ "thunderbird.desktop" ];
    };
  };
}
