{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      font = let
        actualFont = "Source Code Pro";
        c.family = actualFont;
      in {
        normal = c // {
          style = "Regular";
        };
        bold = c // {
          style = "Bold";
        };
        italic = c // {
          style = "Italic";
        };
        bold_italic = c // {
          style = "Bold Italic";
        };
        size = 11.0;
        builtin_box_drawing = false;
      };
    };
  };
}
