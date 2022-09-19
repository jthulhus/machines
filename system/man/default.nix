{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation = {
    man.generateCaches = true;
    dev.enable = true;
  };
}
