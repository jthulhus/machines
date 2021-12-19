{ pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellScriptBin;
  lightSource = readFile ./light.bash;
  lightScript = writeShellScriptBin "light" lightSource;
in
{
  home.packages = [
    lightScript
  ];
}
