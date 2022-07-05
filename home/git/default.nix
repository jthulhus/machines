{
  programs.git = {
    enable = true;
    userName = "BlackBeans";
    userEmail = "adrien.lc.mathieu@gmail.com";
    aliases = {
      co = "checkout";
      st = "status";
    };
    ignores = [
      # Emacs
      "*~"
      # Direnv
      ".direnv/"
      # Nix
      "result"
      # Python
      "__pycache__/"
    ];
  };
}
