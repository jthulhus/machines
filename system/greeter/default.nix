{ lib, ... }: {
  imports = [
    ./greetd.nix
  ];
  
  services.displayManager.ly.enable = true;
}
