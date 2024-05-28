{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zbar
  ];
  programs.password-store = {
    enable = true;
    package = (if config.xserver == "wayland" then pkgs.pass-wayland else pkgs.pass)
      .withExtensions (exts: with exts; [ pass-otp ]);
  };

  home.sessionVariables = {
    PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
  };

  programs.browserpass.enable = true;

  services.pass-secret-service.enable = true;
}
