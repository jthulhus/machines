{ config, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) bool;
  inherit (builtins) listToAttrs filter concatLists;
  inherit (config) my;
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
    config.networking.firewall.allowedTCPPorts = let
      openComponents = filter ({ name, ... }: my.firewall.${name}) components;
      openPorts = map ({
        port ? null,
          ports ? [ ],
          ...
      }: if isNull port then ports else [ port ]
      ) openComponents;
    in concatLists openPorts;
  };
in mkFirewallOptions [
  { name = "clementine"; port = 5500; }
  { name = "wesnoth"; port = 15000; }
  { name = "minecraft"; ports = [ 25565 ]; }
]
