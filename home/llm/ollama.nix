{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [ "qwen2.5-coder:1.5b" "qwen2.5-coder:3b" "deepseek-coder:1.3b" ];
  };
}
