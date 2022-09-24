{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    evscript
  ];

  security.wrappers.evscript = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.evscript}/bin/evscript";
  };
}
