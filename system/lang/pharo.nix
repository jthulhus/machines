{
  security.pam.loginLimits =
    let
      entry = type: {
        inherit type;
        domain = "*";
        item = "rtprio";
        value = "2";
      };
    in [
      (entry "soft")
      (entry "hard")
    ];
}
