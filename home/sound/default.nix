{ pkgs, ... }:
let
  inherit (builtins) readFile;
  inherit (pkgs) writeShellScriptBin;
  soundSource = readFile ./sound.bash;
  soundScript = writeShellScriptBin "sound" soundSource;
in
{
  home.packages = with pkgs; [
    alsa-utils
    pulseaudio
    soundScript
    pavucontrol
  ];
  
}
