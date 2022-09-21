{
  services.xserver.layout = "bsk";
  services.xserver.extraLayouts ={
    bsk = {
      description = "BB Switch";
      symbolsFile = ./bsk;
      languages = [ "eng" "fr" "it" ];
    };
    bru = {
      description = "BB Russian";
      symbolsFile = ./bru;
      languages = [ "ru" ];
    };
  };

  console.useXkbConfig = true;
}
