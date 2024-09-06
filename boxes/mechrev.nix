{ pkgs, lib, ... }:

{
  profile.workstation.enable = true;

  # FIXME: /etc/tmpfiles.d/00-nixos.conf:17: Duplicate line for path "/etc/NetworkManager/system-connections", ignoring.
  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
    "L /var/lib/fprint - - - - /persist/var/lib/fprint"
  ];

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"         = disk "btrfs" "dc500be5-7c43-401a-8a7b-4ce864634e9d";
    "/tmp"      = { device = "none"; fsType = "tmpfs"; options = [ "defaults" "size=10G" "mode=777" ]; };
    "/boot/efi" = disk "vfat"  "9EE5-9912";
    "/boot"     = disk "ext4"  "46def391-7246-42d7-9705-8ef5643c4c83";
    "/nix"      = disk "btrfs" "7e19f401-a857-4eaa-9b13-cc20493dbcf9";
    "/persist"  = disk "ext4"  "df6f0ce4-5a5c-413f-8939-614f3f222e9e";
    "/home"     = disk "ext4"  "84dea802-84ac-4e9d-993d-901eb418808f";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/0b854cfe-5d08-43cc-bb51-13d85676b78d"; } ];

  # Suspend-then-hibernate everywhere
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5m
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=5m";

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

  networking.hostName = "mechrev";
  networking.hostId = "ea1618aa";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  services.tailscale.enable = true;
}
