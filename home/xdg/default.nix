{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
  ];
  
  xdg = let
    inherit (builtins) listToAttrs;
    imageFormats = [ "png" "jpeg" "gif" "svg" "tiff" ];
    imageSupport = apps: listToAttrs (
      map
        (format: { name = "image/${format}"; value = apps; })
        imageFormats
    );
  in {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" "calibre-ebook-viewer.pdf" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      } // imageSupport [ "imv.desktop" "gimp.desktop" ];
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/mailto" = [ "thunderbird.desktop" ];
      } // imageSupport [ "imv.desktop" ];
    };
  };
}
