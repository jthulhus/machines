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
    ];

    programs.bash = {
      enable = true;
      historyFileSize = 2000;
      historySize = 1000;
      historyControl = [ "erasedups" "ignorespace" ];
      shellAliases = {
        ls = "ls --color=tty";
        dd = "dd status=progress";
        vi = "emacsclient --nw";
        nano = "emacsclient -nw";
        vim = "emacsclient --nw";
        t = "trash put";
      };
      shellOptions = [ "histappend" "checkwinsize" "globstar" ];
      initExtra = ''
        function udb() {
          echo Updating databases...
          IFS=':' dbs=($ENCRYPTED_DIRS)
          for dir in "''${dbs[@]}"; do
            if [ -f "$dir/backup" ]; then
              echo "Database for $(basename $dir) is accessibe, updating."
              updatedb -l no -o "$dir/.plocate.db" -U "$dir"
            else
              echo "Database for $(basename $dir) is not accessible, skipping."
            fi
          done
        }

        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '' + (builtins.readFile ./make_prompt.sh);
      sessionVariables = {
        ENCRYPTED_DIRS = concatStringsSep ":" encrypted-directories;
        CALIBRE_USE_DARK_PALETTE = 1;
        LOCATE_PATH = private-locate-dbs;
      };
    };
  };
}
