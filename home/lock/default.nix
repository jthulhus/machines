{ pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellScriptBin;
  lockSource = readFile ./lock.bash;
  lockScript = writeShellScriptBin "lock" lockSource;
in {
  home.packages = [ lockScript ];
}
