{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ecryptfs
    ecryptfs-helper
  ];

  security.pam.enableEcryptfs = true;
}
