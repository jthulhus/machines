{ lib, ... }:
{
  services.nextcloud-client = {
    enable = true;
    startInBackground = lib.mkDefault true;
  };
}
