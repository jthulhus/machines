{ pkgs, config, ... }:
{
  programs.eww = {
    enable = true;
    configDir = ./eww.d;
  };

  systemd.user.services.eww = {
    Unit = {
      Description = "";
      Documentation = "https://elkowar.github.io/eww";
      PartOf = "graphical-session.target";
    };
    Service = {
      Type = "exec";
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      ExecReload = "${config.programs.eww.package}/bin/eww reload";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  services.playerctld.enable = true;
  home.packages = with pkgs; [
    playerctl
    inotify-tools
  ];
}
