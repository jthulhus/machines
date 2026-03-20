{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
  ];

  documentation = {
    man.cache.enable = true;
    dev.enable = true;
  };
}
