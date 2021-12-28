{ lib, ... }: {

  imports = [ ../roles/gaming.nix ../hardware/cybermega.nix ];

  profile.workstation.enable = true;

  boot = {
    supportedFilesystems = [ "zfs" "ntfs" ];
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

        # https://nixos.wiki/wiki/NixOS_on_ZFS
        copyKernels = true;
      };
    };
  };

  nix.maxJobs = 24;

  services.xserver.wacom.enable = true;

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
