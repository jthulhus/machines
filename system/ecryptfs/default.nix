{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ecryptfs
    # ecryptfs-helper
  ];

  boot.kernelModules = [
    "ecryptfs"
  ];
  
  security.pam.enableEcryptfs = true;
}
