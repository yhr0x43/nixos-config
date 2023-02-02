{ pkgs, lib, ... }:

{

  profile.workstation.enable = true;

  programs.custom.sway.enable = true;

  services.fwupd.enable = true;

  # FIXME: /etc/tmpfiles.d/00-nixos.conf:17: Duplicate line for path "/etc/NetworkManager/system-connections", ignoring.
  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
  ];

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"        = disk "ext4" "e3d6307b-664b-41fe-b3a3-4285564593be";
    "/tmp"     = { device = "none"; fsType = "tmpfs"; options = [ "defaults" "size=2G" "mode=777" ]; };
    "/boot"    = disk "vfat"  "C4D9-C179";
    "/nix"     = disk "btrfs" "48577937-aaf6-46ce-9533-03a18be0b9b8";
    "/persist" = disk "ext4"  "7bae81c9-e3e8-4c32-98fe-3275c4db62c3";
    "/home"    = disk "ext4"  "28dfb628-04b9-4d88-bb51-ec390b9aa5a1";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/c67c616f-c10e-4f09-ab43-b8c65586a695"; } ];

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

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
