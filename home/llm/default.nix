{ lib, osConfig, ... }:
let
  inherit (lib.strings) hasPrefix;
  inherit (osConfig.my) gpu;
  gpu-can-handle-llm = gpu: hasPrefix "nvidia" gpu;
in {
  imports = if gpu-can-handle-llm gpu then [
    ./ollama.nix
  ] else [];
}
