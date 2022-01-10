{ lib, ... }:

{

  profile.workstation.enable = true;

  system.custom.fs.bootUuid = "0D56-B89B";

  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];
      };
    };
  };

  networking.networkmanager.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.hostName = "tpx1c";
  networking.hostId = "aa222655";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;
}
