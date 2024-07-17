{ pkgs, config, lib, ... }:
let
  inherit (lib.strings) concatMapStringsSep;
  encrypted-places = [ "em" "er" "ed" "series" "movies" ];
  encrypted-directories = map (dir: "${config.home.homeDirectory}/${dir}") encrypted-places;
  private-locate-dbs = concatMapStringsSep ":" (dir: "${dir}/.plocate.db") encrypted-directories;
in {
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
  for dir in ${concatMapStringsSep " " (dir: "\"${dir}\"") encrypted-directories}; do
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
      CALIBRE_USE_DARK_PALETTE = 1;
      LOCATE_PATH = private-locate-dbs;
    };
  };
}
