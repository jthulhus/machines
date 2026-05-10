{
  programs.nyxt = {
    enable = true;
    config = builtins.readFile ./nyxt.lisp;
  };
}
