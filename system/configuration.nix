{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str listOf;
in
{
  imports = [
    ./bash
    ./bluetooth
    ./boot
    ./cachix.nix
    ./dbus
    ./evscript
    ./fans
    ./firewall
    ./fonts
    ./fs
    ./git
    ./gpg
    ./gpu
    ./greeter
    ./gtk
    ./layouts
    ./locale
    ./locate
    ./man
    ./network
    ./nix
    ./lang
    ./presets.nix
    ./sound
    ./steam
    ./tablet
    ./users
    ./utils
    ./vm
    ./yubico
  ];

  options.my = {
    hostname = mkOption {
      type = str;
      description = "The system hostname.";
    };
    unfree = mkOption {
      type = listOf str;
      description = "List of unfree packages installed.";
      default = [ ];
      example = ''[ "steam" ]'';
    };
  };

  config =
    let
      inherit (lib) getName mkDefault mkIf;
      inherit (builtins) elem;
      inherit (config) my;
    in
    {
      my.unfree = [
        "dwarf-fortress"
        "discord"
        "minecraft-launcher"
        "minecraft-server"
        "aseprite"
        "xkcd-font-unstable"
        "xkcd-font"
        "helvetica-neue-lt-std"
      ];
      nixpkgs.config = {
        allowUnfreePredicate = pkg: elem (getName pkg) my.unfree;
        permittedInsecurePackages = [
          # "python-2.7.18.6"
          "nix-2.16.2"
        ];
      };

      services.emacs.defaultEditor = true;

      services.openssh.enable = true;

      networking.hostName = my.hostname;

      time.timeZone = mkDefault "Europe/Paris";

      networking.useDHCP = false;

      console = {
        font = "Lat2-Terminus16";
      };

      services = {
        printing = {
          enable = true;
          drivers = with pkgs; [
            hplip
            cups-filters
            cups-browsed
            gutenprint
            brlaser
          ];
        };
        avahi = {
          enable = true;
          nssmdns4 = true;
          openFirewall = true;
        };
      };
    };
}
