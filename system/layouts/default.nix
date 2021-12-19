{
  services.xserver.layout = "bsk";
  services.xserver.extraLayouts.bsk = {
    description = "BB Switch";
    symbolsFile = ./bsk;
    languages = [ "eng" "fr" "it" ];
  };

  console.useXkbConfig = true;
}
