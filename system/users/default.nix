{
  users = {
    mutableUsers = false;
    users = {
      adri = import ./adri.nix;
      lol = import ./lol.nix;
      # mala = import ./mala.nix;
    };
  };
}
