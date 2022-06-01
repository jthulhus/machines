{ config, lib, ... }:
let
  inherit (lib) mkOption mkIf mkDefault mkMerge;
  inherit (lib.types) enum nullOr;
  inherit (config) my;
  inherit (builtins) foldl';
  dTrue = mkDefault true;
  mkSwitch = value: cases: mkMerge (map ({ case, do }: mkIf (case == value) do) cases);
in {
  options.preset = mkOption {
    type = nullOr (enum [ "server" "personal" ]);
    default = null;
    example = "personal";
    description = "Usual preset of modules";
  };

  config = mkSwitch config.preset [
    { case = "server";
      do = {
        my.gitea = dTrue;
      };
    }
    { case = "personal";
      do = {
        my = {
          firewall = {
            clementine = dTrue;
            wesnoth = dTrue;
            minecraft = dTrue;
          };
          virt = true;
        };
        programs.sway = {
          enable = dTrue;
          extraOptions = mkIf (my.gpu == "nvidia-proprietary") (mkDefault [ "--unsupported-gpu" ]);
        };
      };
    }
  ];
}
