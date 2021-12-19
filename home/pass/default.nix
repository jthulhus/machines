{ pkgs, config, ... }:
{
  programs.password-store = {
    enable = true;
    package = if config.xserver == "wayland" then pkgs.pass-wayland else pkgs.pass;
  };

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };

  programs.browserpass.enable = true;
}
