{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    yubikey-personalization
    yubioath-flutter
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.pcscd.enable = true;
}
