{ pkgs, lib, ... }:

{

  # profile.desktop.enable = true;
  profile.workstation.enable = true;
  profile.gaming.enable = true;

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
    "/"        = disk "btrfs" "fa660e70-6e0f-4da9-8c79-4fc01f9f504a";
    "/boot"    = disk "vfat"  "F5BA-F32B";
    "/nix"     = disk "ext4"  "dd9e6a97-d200-4d65-97e4-eb99b98ea277";
    "/persist" = disk "ext4"  "f387b609-f85b-4595-9b7c-dc4c188c2fb1";
    "/home"    = disk "ext4"  "8f899207-ab8c-4288-9469-fa626521e4db";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/89ccf3d5-c129-4345-a5a5-5b3cacccce09"; } ];

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
