{
  boot.supportedFilesystems = [
    "fat32"
    "ntfs"
  ];

  services = {                  # auto-mount
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
  };

  security.pam.enableFscrypt = true;
}
