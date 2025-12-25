{ pkgs, ... }:
{
  programs.beets = {
    enable = true;
    # package = pkgs.beets.override {
    #   pluginOverrides = {
    #     chroma.enable = true;
    #     lyrics.enable = true;
    #   };
    # };
    settings = {
      directory = "~/music";
      plugins = [ "chroma" "lyrics" ];
      asciify_paths = true;
      max_filename_length = 134;
      "import" = {
        write = "yes";
        move = "yes";
      };
      paths = {
        default = "%lower{$albumartist}/%lower{$album}%aunique{}/$track.%lower{$title}";
      };
    };
  };
}
