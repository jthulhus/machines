{ pkgs, ... }:
{
  home.file.".emacs.d" = {
    source = ./emacs.d;
    recursive = true;
  };
    
  
  programs.emacs = {
    enable = true;
    package = with pkgs; emacsWithPackagesFromUsePackage {
      config = ./emacs.d/init.org;
      package = emacs-pgtk;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
        zenburn-theme
        (melpaBuild {
          pname = "kbd-mode";
          version = "1";
          commit = "1";
          src = pkgs.kbd-mode;
          packageRequires = [];
          recipe = writeText "recipe" ''
            (kbd-mode
              :repo "kmonad/kbd-mode"
              :fetcher github
              :files ("*.el"))
          '';
        })
        (melpaBuild {
          pname = "lean4-mode";
          version = "1";
          commit = "1";
          src = pkgs.lean4-mode;
          packageRequires = with melpaPackages; [
            dash
            f
            flycheck
            magit-section
            lsp-mode
            s
          ];
          recipe = writeText "recipe" ''
            (lean4-mode
              :repo "leanprover/lean4-mode"
              :fetcher github
              :files ("*.el" "data"))
          '';
        })
        (treesit-grammars.with-grammars (grammars: with grammars; [
          tree-sitter-bash
          tree-sitter-latex
          tree-sitter-nix
          tree-sitter-ocaml
          tree-sitter-ocaml-interface
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-toml
        ]))
      ];
    };
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };
  

  home.packages = with pkgs; [
    # LaTeX
    # auctex
    stable.texlive.combined.scheme-full
    pandoc

    # Python
    nodePackages.pyright

    # Nix
    nixd

    # # OCaml
    # ocamlPackages.findlib
    # ocamlPackages.merlin
    # ocamlPackages.ocp-indent
    # ocamlPackages.utop

    # Flyspell
    (aspellWithDicts (dictionaries: with dictionaries; [
      fr
      en
      it
    ]))

  ];
}
