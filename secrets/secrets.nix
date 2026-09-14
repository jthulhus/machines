let
  rlyeh = "age13aza84d34mwd2aja37rw3uq00gk9d7yg7fl53g50496wxvx6ly5sk3xst5";
  alice = "age1sla03s6uezffkqlu7tmff5kd2jmluazxvxqs7ha5y5ts4rlffe0q5zwhww";
in {
  "pia-credentials.age" = {
    script = ''
      secrets=$(pass pia/login)
      username=$(echo "$secrets" | cut -d $'\n' -f 2)
      username=''${username#login: }
      password=$(echo "$secrets" | cut -d $'\n' -f 1)
      echo "$username"
      echo "$password"
    '';
    publicKeys = [
      alice
      rlyeh
    ];
  };
  "nextcloud-credentials.age" = {
    script = ''
      secrets=$(pass web/2mon.ad/jthulhu)
      username=$(echo "$secrets" | cut -d $'\n' -f 2)
      username=''${username#login: }
      password=$(echo "$secrets" | cut -d $'\n' -f 1)
      cat <<EOF
      [PushProvider]
      Type=NextPush

      [NextPush]
      Url=https://2mon.ad
      Username=$username
      AppPassword=$password
      EOF
    '';
    publicKeys = [
      alice
      rlyeh
    ];
  };
}
