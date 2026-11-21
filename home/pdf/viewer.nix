{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pdfpc
  ];

  programs = {
    zathura.enable = true;

    sioyek = {
      enable = true;
      config.startup_commands = [
        "toggle_dark_mode"
      ];
    };
  };
}
