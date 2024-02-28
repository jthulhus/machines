{ pkgs, ... }: {
  services.xserver.layout = "bsk";
  services.xserver.extraLayouts = {
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
    jkb = {
      description = "Jthulhu's keyboard";
      symbolsFile = ./jkb;
      languages = [ "eng" "fr" "it" ];
    };
  };

  # services.udev.extraRules = ''
  #   KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput", GROUP="input", MODE="0600  '';

  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [
    qmk
    qmk-udev-rules
  ];

  console.useXkbConfig = true;
}
