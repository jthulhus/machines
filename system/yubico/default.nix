{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [
    yubikey-personalization
    yubikey-personalization-gui
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.pcscd.enable = true;
}
