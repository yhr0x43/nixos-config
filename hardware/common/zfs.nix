{ lib, ... } : {
  # / is wiped on every boot to keep unmanaged state under control
  fileSystems."/" = {
    device = "rpool/expendable/wipedonboot";
    fsType = "zfs";
  };
  #TODO: wipe /
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
    device = "/dev/disk/by-uuid/0A5E-C2D1";
    fsType = "vfat";
  };

  # Remember NixOS configuration
  environment.etc."nixos" = { source = "/persist/etc/nixos/"; };

  # Remember user credentials
  environment.etc."shadow" = { source = "/persist/etc/shadow"; };
  environment.etc."shadow-" = { source = "/persist/etc/shadow-"; };

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

  # ZFS services
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
    trim.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  ''; # zfs already has its own scheduler. without this my(@Artturin) computer froze for a second when i nix build something.

}
