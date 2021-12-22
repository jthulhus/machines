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
      package = emacsPgtkGcc;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
        zenburn-theme
      ];
    };
  };

  home.packages = with pkgs; [
    # LaTeX
    auctex
    texlive.combined.scheme-full
    pandoc

    # Python
    nodePackages.pyright

    # Nix
    rnix-lsp

    # OCaml
    ocamlPackages.findlib
    ocamlPackages.merlin
    ocamlPackages.ocp-indent
    ocamlPackages.utop
  ];
}
