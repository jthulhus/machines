{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.blacklistedKernelModules = [
    "mei"
    "mei_me"
    "mei_hdcp"
    "mei_pxp"
  ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  boot.initrd.luks.devices."cryptroot" = {
    device = "/dev/disk/by-uuid/bf9fc1ac-04ed-47bf-a7ac-d44797b07b55";
    crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
