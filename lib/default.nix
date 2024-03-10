inputs: config: {
  mkHome = import ./make_home.nix inputs config;
  mkSystem = import ./make_system.nix inputs config;
}
