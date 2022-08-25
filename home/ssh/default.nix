{
  home.file.".ssh/hosts/rem".source = ./rem.cfg;
  programs.ssh = {
    enable = true;
    includes = [
      "~/.ssh/hosts/*"
    ];
  };
}
