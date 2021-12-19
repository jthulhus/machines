{
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
PS1=${dollar}{PS1//'\n'/} # Remove newline in PS1

if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
'';
  };
}
