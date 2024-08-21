{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
