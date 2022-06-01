{ pkgs, ... }:
{
  imports = [
    ./gitea.nix
  ];

  environment.systemPackages = with pkgs; [
    git
  ];
}
