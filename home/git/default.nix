{
  programs.git = {
    enable = true;
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = null;
    };
    settings = {
      alias = {
        co = "checkout";
        st = "status";
        tree = "log --graph --format='format:%C(dim red)%h%Creset %s %C(brightblue)%d'";
        tr = "tree";
      };
      user = {
        name = "jthulhu";
        email = "jthulhu@posteo.net";
      };
      init = {
        defaultBranch = "main";
      };
      push.autoSetupRemote = true;
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
      # Rust
      "target/"
      # Dune
      "_build/"
      # Lean
      "build/"
      # LaTeX
      "*.log"
      "*.aux"
      "*.out"
      "*.toc"
      "*.bbl"
      "*.blg"
      "_minted-*/"
    ];
  };
}
