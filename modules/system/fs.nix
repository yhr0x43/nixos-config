{ config, lib, ... }:

with lib;

let

  cfg = config.system.custom.fs;

in {
  options.system.custom.fs = {
    enable = mkEnableOption "custom zfs config";
    bootUuid = mkOption {
      default = "0000-0000";
      description = ''
        boot partition is expected to be vfat,
        this option sets the UUID of the boot drive
      '';
      example = "0A5E-C2D1";
      type = types.str;
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # wipe /
      boot.initrd.postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/expendable/wipedonboot@blank
      '';

      # ZFS services
      services.zfs = {
        autoSnapshot.enable = true;
        autoScrub.enable = true;
        trim.enable = true;
      };

      # https://nixos.wiki/wiki/NixOS_on_ZFS
      boot.loader.grub.copyKernels = true;

      # FIXME: hibernation could be helpful on laptop
      boot.kernelParams = [ "nohibernate" ];

      boot.initrd.supportedFilesystems = ["zfs"]; # boot from zfs
      boot.supportedFilesystems = [ "zfs" ];
      services.udev.extraRules = ''
        ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
      '';

      fileSystems = {
        # / is wiped on every boot to keep unmanaged state under control
        "/" = {
          device = "rpool/expendable/wipedonboot";
          fsType = "zfs";
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/${cfg.bootUuid}";
          fsType = "vfat";
        };

        "/nix" = {
          device = "rpool/expendable/nix";
          fsType = "zfs";
        };

        # This is where precious system state outside /home is stored
        "/persist" = {
          device = "rpool/precious/systempersist";
          fsType = "zfs";
        };

        "/home" = {
          device = "rpool/precious/home";
          fsType = "zfs";
        };
      };
    })
    (mkIf true {
      environment.etc = {
        # Remember NixOS configuration
        "nixos".source = "/persist/etc/nixos/";

        # Remember user credentials
        "shadow".source = "/persist/etc/shadow";
        "shadow-".source = "/persist/etc/shadow-";
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
          { path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }

          { path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
      };
    })
  ];
}
