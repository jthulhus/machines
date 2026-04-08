{
  programs.btop = {
    enable = true;
  };
  
  programs.bash.shellAliases = {
    top = "btop";
    emacs = "emacs --no-desktop";
  };
}
