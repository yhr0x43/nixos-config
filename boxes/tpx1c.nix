{ lib, ... }: {

  imports = [ ../roles/workstation.nix ../roles/gaming.nix ../hardware/tpx1c.nix ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];

        # https://nixos.wiki/wiki/NixOS_on_ZFS
        copyKernels = true;
      };
    };
  };
  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  ''; # zfs already has its own scheduler. without this my(@Artturin) computer froze for a second when i nix build something.


  networking.networkmanager.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.hostName = "tpx1c";
  networking.hostId = "aa222655";

  # / is wiped on every boot to keep unmanaged state under control
  fileSystems."/" = {
    device = "rpool/expendable/wipedonboot";
    fsType = "zfs";
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/expendable/wipedonboot@blank
  '';

  fileSystems."/nix" = {
    device = "rpool/expendable/nix";
    fsType = "zfs";
  };

  # This is where precious system state outside /home is stored
  fileSystems."/persist" = {
    device = "rpool/precious/systempersist";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/precious/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0D56-B89B";
    fsType = "vfat";
  };


  environment.etc = {
    # Remember NixOS configuration
    "nixos" = { source = "/persist/etc/nixos/"; };
    # Remember user credentials
    "shadow" = { source = "/persist/etc/shadow"; };
    "shadow-" = { source = "/persist/etc/shadow-"; };
    # Remember Networkmanager connections
    "NetworkManager/system-connections" = { source = "/persist/etc/NetworkManager/system-connections"; };
  };

  systemd.tmpfiles.rules = [
    # Remember Bluetooth pairings
    "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    # Remember lectured sudo users
    "L /var/db/sudo/lectured - - - - /persist/var/db/sudo/lectured"
  ];

  # Remember SSH host keys
  services.openssh = {
    hostKeys = [
      {
        path = "/persist/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/persist/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;

  # ZFS services
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    trim.enable = true;
  };

  # Allegedly, ZFS does not like the kernel scheduler messing with it
  # TODO: Research how to set this only for /dev/sda
  boot.kernelParams = [ "elevator=none" ];
}
