{ pkgs, ... }:
{
  environment.systemPackage = with pkgs; [
    evscript
  ];

  security.wrappers.evscript = {
    setuid = true;
    owner = "root";
    source = "${pkgs.evscript}/bin/evscript";
  };
}
