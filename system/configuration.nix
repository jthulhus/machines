{ config, lib, pkgs, ... }:
let
  inherit (lib) types mkIf mkOption;
in
{
  imports = [
    ./users
    ./boot
    ./layouts
    ./nix
    ./network
    ./dbus
    ./sound
    ./utils
    ./fs
    ./games
    ./vm
    ./fonts
    ./gnome
  ];

  options.my = {
    boot = {
      mode = mkOption {
        type = types.enum [ "bios" "uefi" ];
        default = "uefi";
        example = "bios";
        description = "The motherboard's boot loader.";
      };
      device = mkOption {
        type = types.str;
        default = "/dev/sda";
        description = "The device grub loads.";
      };
    };
    steam = mkOption {
      type = types.bool;
      default = false;
      example = "true";
      description = "Whether to enable steam.";
    };
    hostname = mkOption {
      type = types.str;
      description = "The system hostname.";
    };
    gpu = mkOption {
      # For now, this assumes only one GPU.
      type = types.enum [ "nvidia-proprietary" "nvidia-nouveau" "intel" "amd" "none" ];
      example = "nvidia";
      description = "What GPU drivers are required.";
    };
  };

  config = let
    inherit (lib) getName;
    inherit (builtins) elem;
    allowedUnfree = let
      inherit (lib) optional;
      inherit (builtins) foldl';
      optionalList = b: l: foldl' (x: y: x ++ y) [ ] (map (optional b) l);
    in 
      optionalList config.my.steam [ "steam" "steam-runtime" "steam-original" ]
      ++ optionalList (config.my.gpu == "nvidia-proprietary") [ "nvidia-x11" "nvidia-settings" ];
  in {
    nixpkgs.config.allowUnfreePredicate = pkg: elem (getName pkg) allowedUnfree;

    services.emacs.defaultEditor = true;

    programs.steam.enable = config.my.steam;

    services.openssh.enable = true;

    networking.hostName = config.my.hostname;

    time.timeZone = "Europe/Paris";

    networking.useDHCP = false;

    console = {
      font = "Lat2-Terminus16";
    };

    services.xserver.videoDrivers = mkIf (config.my.gpu == "nvidia-proprietary") [ "nvidia" ];

    services = {
      printing.enable = true;
    };

    networking.firewall.allowedTCPPorts = [
      5500                      # Clementine
      15000                     # Wesnoth
    ];
    
    system.stateVersion = "20.09";
  };
}
