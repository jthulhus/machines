{ pkgs, ... }:
let
  myRust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rustfmt-preview" "clippy-preview" ];
  };
  myCargo = pkgs.rust-bin.stable.latest.cargo;
in {
  home.packages = with pkgs; [
    myRust
    myCargo
    gcc
  ];
}
