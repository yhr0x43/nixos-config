{ lib, pkgs, ... }:

{
  profile.workstation.enable = true;
  profile.gaming.enable = true;

  system.custom.fs.enable = true;
  system.custom.fs.bootUuid = "0A5E-C2D1";

  boot = {
    supportedFilesystems = [ "ntfs" ];
    zfs.requestEncryptionCredentials = true;
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    #kernelModules = [ "kvm-amd" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];
      };
    };
  };

  nix.maxJobs = 24;

  services.dnsmasq = {
    enable = true;
    extraConfig = "address=/k26.local/192.168.1.2";
  };

  networking.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;

  networking.hostName = "cybermega";
  networking.hostId = "6964344f";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;
}
