{ pkgs, lib, ... }:

{

  profile.workstation.enable = true;

  services.fwupd.enable = true;

  # FIXME: /etc/tmpfiles.d/00-nixos.conf:17: Duplicate line for path "/etc/NetworkManager/system-connections", ignoring.
  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
    "L /var/lib/fprint - - - - /persist/var/lib/fprint"
  ];

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"         = disk "btrfs" "39b522ab-bd28-4cea-8c0b-e4f389348012";
    "/tmp"      = { device = "none"; fsType = "tmpfs"; options = [ "defaults" "size=10G" "mode=777" ]; };
    "/boot/efi" = disk "vfat"  "8162-2814";
    "/boot"     = disk "ext4"  "b4e11135-9e7d-41ae-a21f-4a7f24a8c247";
    "/nix"      = disk "btrfs" "6ea8084e-781e-4002-aa06-61f9a0cc572e";
    "/persist"  = disk "ext4"  "4e404564-e24d-43f5-aeb8-a563e8f60320";
    "/home"     = disk "ext4"  "a59c80cd-414f-4a81-873d-b1a8aa6fa384";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/f008b362-b5e1-4a79-bb85-f08de3e65c7b"; } ];

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
      grub = {
        enable = true;
        efiSupport = true;
        default = "saved";
        device = "nodev";
        useOSProber = true;
      };
    };
  };

  # dual boot compatibility with Windows
  time.hardwareClockInLocalTime = true;

  networking.networkmanager.enable = true;
  networking.interfaces.wlp166s0.useDHCP = true;

  networking.hostName = "frame";
  networking.hostId = "b199ed4f";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  services.tailscale.enable = true;
}
