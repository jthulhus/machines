{ pkgs, config, ... }:
{
  home = {
    packages = with pkgs; [
      swappy
    ];
    file."${config.xdg.configHome}/swappy/config".source = ./config;
  };
}
