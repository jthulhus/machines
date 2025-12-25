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
      package = emacs-git-pgtk;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
        zenburn-theme
        (melpaBuild {
          pname = "kbd-mode";
          version = "1";
          commit = "1";
          src = pkgs.kbd-mode;
          packageRequires = [ ];
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
              :fetcher codeberg
              :files ("*.el"))
          '';
        })
        (treesit-grammars.with-grammars (grammars: with grammars; [
          tree-sitter-bash
          tree-sitter-c
          tree-sitter-cmake
          tree-sitter-cpp
          tree-sitter-css
          tree-sitter-elisp
          tree-sitter-haskell
          tree-sitter-html
          tree-sitter-json
          tree-sitter-latex
          tree-sitter-llvm
          tree-sitter-make
          tree-sitter-markdown
          tree-sitter-nix
          tree-sitter-ocaml
          tree-sitter-ocaml-interface
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-scheme
          tree-sitter-scss
          tree-sitter-toml
          tree-sitter-typst
          tree-sitter-yaml
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
    texliveFull
    # texlive.combined.scheme-full
    texlab
    pandoc

    # Python
    pyright

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
    typstyle

    emacs-all-the-icons-fonts

    # Flyspell
    python3Packages.grammalecte
    (aspellWithDicts (dictionaries: with dictionaries; [
      fr
      en
      it
    ]))

  ];
}
