{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    rustic
  ];

  xdg.configFile."rustic/rustic.toml".source = (pkgs.formats.toml { }).generate "rustic-config" {
    repository = {
      repository = "${config.home.homeDirectory}/media/jthulhu-backup/bak";
      password-command = "pass backup/rustic/square";
      no-cache = true;
    };

    backup = {
      snapshots = [
        {
          name = "data";

          sources = map (path: "${config.home.homeDirectory}/${path}") ([
            "bocal"
            "budget"
            "dev"
            "dnd"
            "doc"
            "incoming"
            "memes"
            "movies"
            "music"
            "music.in"
            "org"
            "others"
            "scores"
            "screens"
            "series"
          ] ++ map (path: ".local/share/${path}") [
            "inv"
            "password-store"
            "wesnoth"
            "zathura"
          ]);
        }
        {
          name = "gpg";
          
          sources = map (path: "${config.home.homeDirectory}/.gnupg/${path}") [
            "private-keys-v1.d"
            "openpgp-revocs.d"
            "pubring.kbx"
            "trustdb.gpg"
          ];
        }
        {
          name = "ssh";

          sources = map (path: "${config.home.homeDirectory}/.ssh/${path}") [
            "bootstrap"
            "bootstrap.pub"
            "gh-cli"
            "gh-cli.pub"
            "id_ed25519"
            "id_ed25519.pub"
            "xiaomi"
            "xiaomi.pub"

            "known_hosts"
            "known_hosts.old"
          ];
        }
      ];
      git-ignore = true;
      exclude-if-present = [ ".nobackup" ];
    };
  };
}
