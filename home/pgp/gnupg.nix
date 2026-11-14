{ pkgs, ... }: 
{
  programs.gpg = {
    enable = true;
    package = pkgs.sequoia-chameleon-gnupg;
  };
  services.gpg-agent = {
    enable = true;
    extraConfig = "no-allow-external-cache";
  };
}
