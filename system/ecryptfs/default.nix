{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ecryptfs
    ecryptfs-helper
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.7"           # Thanks, ecryptfs-helper...
  ];

  boot.kernelModules = [
    "ecryptfs"
  ];
  
  security.pam.enableEcryptfs = true;
}
