{ pkgs, lib, ... }:

{

  profile.workstation.enable = true;

  services.fwupd.enable = true;

  # FIXME: /etc/tmpfiles.d/00-nixos.conf:17: Duplicate line for path "/etc/NetworkManager/system-connections", ignoring.
  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
  ];

  # FIXME: supposedly wifi do not work properly for linux version below 5.16?
  # FIXME: black screen on boot when on kernel 5.18
  boot.kernelPackages = pkgs.linuxPackages;

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"        = disk "btrfs" "5c4ce66e-f893-4d52-a5a7-3ce18399c33e";
    "/boot"    = disk "vfat"  "75D3-A8FD";
    "/nix"     = disk "btrfs" "981e3321-ebd4-40c5-ab67-171d65775310";
    "/persist" = disk "ext4"  "ab2a2b3d-e657-4b26-aeea-54ab73d605cf";
    "/home"    = disk "ext4"  "4f615243-d97e-4ca3-8332-1a0fe3cf7f70";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/2373c16e-d942-413b-8b39-33bad96a2a8d"; } ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  networking.networkmanager.enable = true;
  networking.interfaces.wlp166s0.useDHCP = true;

  networking.hostName = "frame";
  networking.hostId = "007f0200";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  services.tailscale.enable = true;
}
