{ pkgs, config, lib, ... }:
let
  inherit (lib.strings) concatMapStringsSep concatStringsSep;
  encrypted-directories = map (dir: "${config.home.homeDirectory}/${dir}") config.my.encrypted-places;
  private-locate-dbs = concatMapStringsSep ":" (dir: "${dir}/.plocate.db") encrypted-directories;
in
{
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      my.encrypted-places = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = ''
          Directories right under the home that are encrypted.
        '';
      };
    };
  config = {
    home.packages = with pkgs; [
      isgit
      rgrc
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      defaultKeymap = "emacs";
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        append = true;
        expireDuplicatesFirst = true;
      };
    };

    programs.command-not-found.enable = false;
    
    programs.bash = {
      enable = true;
      historyFileSize = 2000;
      historySize = 1000;
      historyControl = [ "erasedups" "ignorespace" ];
      shellAliases = {
        ls = "lsd";
        dd = "dd status=progress";
        vi = "emacsclient --nw";
        nano = "emacsclient -nw";
        vim = "emacsclient --nw";
        t = "trash put";
        df = "rgrc df";
        diff = "rgrc diff";
        dig = "rgrc dig";
        du = "rgrc du";
        env = "rgrc env";
        fdisk = "rgrc fdisk";
        free = "rgrc free";
        gpg = "rgrc gpg";
        ifconfig = "rgrc ifconfig";
        ip = "rgrc ip";
        mount = "rgrc mount";
        ping = "rgrc ping";
        ps = "rgrc ps";
      };
      shellOptions = [ "histappend" "checkwinsize" "globstar" ];
      initExtra =  (builtins.readFile ./make_prompt.sh) + ''
        source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
      '';
      sessionVariables = {
        ENCRYPTED_DIRS = concatStringsSep ":" encrypted-directories;
        LOCATE_PATH = private-locate-dbs;
        SSH_ASKPASS =  pkgs.writeScript "pass-ssh" ''
          #!${lib.getExe pkgs.bash}
          ${lib.getExe pkgs.pass-wayland} ssh/jthulhu
        '';
        SSH_ASKPASS_REQUIRE = "force";
        NIXOS_OZONE_WL = 1;
      };
    };
  };
}
