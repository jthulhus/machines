{ pkgs,  secrets, lib, ... }:
let
  inherit (lib) getExe;
in {
  systemd.user.services.kunifiedpush-distributor = {
    Unit = {
      Description = "KUnifiedPush Distributor Service";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = pkgs.writeShellScript "setup-kunifiedpush-secrets" ''
        SECRET_PATH=${secrets.nextcloud-credentials.path}
        TARGET_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/KDE/kunifiedpush-distributor.conf"

        # Avoid race conditions by checking that this file exists.        
        until [ -f "$SECRET_PATH" ]; do
          sleep 0.02
        done

        mkdir -p "$(dirname "$TARGET_PATH")"

        ln -sf "$SECRET_PATH" "$TARGET_PATH"
      '';
      ExecStart = "${getExe pkgs.kdePackages.kunifiedpush}";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
