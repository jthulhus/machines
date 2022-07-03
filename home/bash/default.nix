{ pkgs, ... }:
{
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
    };
    shellOptions = [ "histappend" "checkwinsize" "globstar" ];
    initExtra = let
      dollar = "$";
    in ''
if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
'' + (builtins.readFile ./make_prompt.sh);
  };
}
