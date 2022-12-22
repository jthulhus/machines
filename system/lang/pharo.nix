{
  security.pam.services.pharo.limits =
    let
      entry = type: { inherit type; domain = "*"; item = "rtprio"; value = "2"; };
    in [
      (entry "soft")
      (entry "hard")
    ];
}
