{ pkgs, ... }:
let
  pyPkgs = pypkgs: with pypkgs; [
    ptpython
    ipython
    pygments
    numpy
    matplotlib
  ];
in {
  home.packages = with pkgs; [
    (python3.withPackages pyPkgs)
  ];
}
