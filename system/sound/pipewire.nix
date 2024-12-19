{ config, ... }:
{
  security.rtkit.enable = config.my.audio;
  services.pipewire = {
    enable = config.my.audio;
    alsa.enable = config.my.audio;
    pulse.enable = config.my.audio;
  };
}
