{ config, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
  inherit (builtins) listToAttrs filter concatLists;
  inherit (config) my;
  enable-tcp-by-default = true;
  enable-udp-by-default = false;
  mkFirewallOptions = components: {
    options.my.firewall = listToAttrs (
      map ({ name, ... }: {
        inherit name;
        value = mkOption {
          type = bool;
          default = false;
          example = "true";
          description = "Whether to open ${name}'s port";
        };
      }) components);
    config.networking.firewall = {
      allowedTCPPorts = let
        openComponents = filter ({ name, tcp ? enable-tcp-by-default, ... }:
          tcp && my.firewall.${name}) components;
        openPorts = map ({
          port ? null,
            ports ? [ ],
            ...
        }: if isNull port then ports else [ port ]
        ) openComponents;
      in concatLists openPorts;

      allowedTCPPortRanges = let
        openComponents = filter ({ name, tcp ? enable-tcp-by-default, ... }:
          tcp && my.firewall.${name}) components;
        openPorts = map ({ port-ranges ? [ ], ... }: port-ranges) openComponents;
      in concatLists openPorts;

      allowedUDPPorts = let
        openComponents = filter ({ name, udp ? enable-udp-by-default, ... }:
          udp && my.firewall.${name}) components;
        openPorts = map ({
          port ? null,
            ports ? [ ],
            ...
        }: if isNull port then ports else [ port ]
        ) openComponents;
      in concatLists openPorts;

      allowedUDPPortRanges = let
        openComponents = filter ({ name, udp ? enable-udp-by-default, ... }:
          udp && my.firewall.${name}) components;
        openPorts = map ({ port-ranges ? [ ], ... }: port-ranges) openComponents;
      in concatLists openPorts;
    };
  };
in mkFirewallOptions [
  { name = "clementine"; port = 5500; }
  { name = "wesnoth"; port = 15000; }
  { name = "minecraft"; ports = [ 25565 ]; }
  { name = "ssdp";
    ports = [ 1900 49152 ];
    port-ranges = [ { from = 32768; to = 60999; } ];
    udp = true; }
]
