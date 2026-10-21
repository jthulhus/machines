{
  services.open-webui = {
    enable = false;
    port = 8080;

    environment = rec {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      OLLAMA_API_BASE_URL = "${OLLAMA_BASE_URL}/api";
      WEBUI_AUTH = "False";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
    };
  };
}
