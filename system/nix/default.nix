{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix;

    settings = {
      auto-allocate-uids = true;
      use-cgroups = true;
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" "cgroups" ];
      extra-system-features = [ "uid-range" ];
    };
  };

  systemd.services.nix-daemon.serviceConfig = { 
    Delegate = true;
  };
}
