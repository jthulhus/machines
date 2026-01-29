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

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      defaultKeymap = "emacs";
      history = {
        append = true;
        expireDuplicatesFirst = true;
      };
    };

    programs.command-not-found.enable = true;
    
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
      };
      shellOptions = [ "histappend" "checkwinsize" "globstar" ];
      initExtra = ''
        function iter_open_ed() {
          IFS=':' dbs=($ENCRYPTED_DIRS)
          for dir in "''${dbs[@]}"; do
            if [ -f "$dir/backup" ]; then
              $* "$dir"
            fi
          done
        }

        function iter_closed_ed() {
          IFS=':' dbs=($ENCRYPTED_DIRS)
          for dir in "''${dbs[@]}"; do
            if [ ! -f "$dir/backup" ]; then
              $* "$dir"
            fi
          done
        }

        function iter_ed() {
          IFS=':' dbs=($ENCRYPTED_DIRS)
          for dir in "''${dbs[@]}"; do
            if [ -f "$dir/backup" ]; then
              $1 "$dir"
            else
              $2 "$dir"
            fi
          done
        }

        function udb() {
          echo Updating databases...
          ho() {
            echo "Database for $(basename $1) is accessible, updating."
            updatedb -l no -o "$1/.plocate.db" -U "$1"
          }
          hc() {
            echo "Database for $(basename $1) is not accessible, skipping."
          }
          iter_ed ho hc
        }

        function backup_all() {
          echo Backing up
          if [ ! -d ~/media/Adrien ]; then
            echo "error: no backup media"
            return
          fi

          ho() {
            echo "Backing up $1..."
            mntm $(basename "$1")
            pushd "$1"
            ./backup
            popd
            umntm $(basename "$1")
          }
          hc() {
            mnt "$1"
            ho "$1"
            umnt "$1"
          }
        }

        function make_mnt_completions() {
          IFS=':' dbs=($ENCRYPTED_DIRS)
          dbs_bn=()
          for dir in "''${dbs[@]}"; do
            dbs_bn+=($(basename $dir))
          done
          complete -W "''${dbs_bn[*]}" mnt
          complete -W "''${dbs_bn[*]}" umnt
          complete -W "''${dbs_bn[*]}" mntm
          complete -W "''${dbs_bn[*]}" umntm
        }
        make_mnt_completions

        if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec sway
        fi
      '' + (builtins.readFile ./make_prompt.sh);
      sessionVariables = {
        ENCRYPTED_DIRS = concatStringsSep ":" encrypted-directories;
        CALIBRE_USE_DARK_PALETTE = 1;
        LOCATE_PATH = private-locate-dbs;
        SSH_ASKPASS = "/home/adri/.local/bin/pass-ssh";
        SSH_ASKPASS_REQUIRE = "force";
        NIXOS_OZONE_WL = 1;
      };
    };
  };
}
