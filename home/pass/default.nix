{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    zbar
  ];
  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland
      .withExtensions (exts: with exts; [ pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };

  programs.browserpass.enable = true;

  services.pass-secret-service.enable = true;
}
