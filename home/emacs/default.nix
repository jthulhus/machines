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
        (melpaBuild {
          pname = "typst-preview";
          version = "1";
          commit = "1";
          src = pkgs.typst-preview;
          packageRequires = with melpaPackages; [
            websocket
          ];
          recipe = writeText "recipe" ''
            (typst-preview
              :repo "havarddj/typst-preview.el"
              :fetcher github
              :files ("*.el"))
          '';
        })
        (melpaBuild {
          pname = "typst-ts-mode";
          version = "1";
          commit = "1";
          src = pkgs.typst-ts-mode;
          recipe = writeText "recipe" ''
            (typst-ts-mode
              :repo "meow_king/typst-ts-mode"
              :fetcher sourcehut
              :files ("*.el"))
          '';
        })
        (treesit-grammars.with-grammars (grammars: with grammars; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cpp
          tree-sitter-latex
          tree-sitter-nix
          tree-sitter-ocaml
          tree-sitter-ocaml-interface
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-toml
          tree-sitter-typst
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
    texlive.combined.scheme-full
    pandoc

    # Python
    nodePackages.pyright

    # Nix
    nixd
    nixpkgs-fmt

    # # OCaml
    # ocamlPackages.findlib
    # ocamlPackages.merlin
    # ocamlPackages.ocp-indent
    # ocamlPackages.utop

    # Rust
    rust-analyzer

    # Typst
    typst
    # typst-lsp
    tinymist
    typst-fmt

    emacs-all-the-icons-fonts

    # Flyspell
    (aspellWithDicts (dictionaries: with dictionaries; [
      fr
      en
      it
    ]))

  ];
}
