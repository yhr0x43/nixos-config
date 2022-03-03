{ lib, ... }:

{

  profile.workstation.enable = true;

  systemd.tmpfiles.rules = [
    "L /etc/NetworkManager/system-connections - - - - /persist/etc/NetworkManager/system-connections"
  ];

  fileSystems = let disk = fsType: uuid: { inherit fsType; device = "/dev/disk/by-uuid/${uuid}"; };
  in {
    "/"        = disk "ext4" "f2c570f5-5e13-4c71-ae53-32627b7c17da";
    "/boot"    = disk "vfat" "ECC8-A7DD";
    "/nix"     = disk "ext4" "51c2c29b-d73a-4f06-89fb-1ed26ffcfb9b";
    "/persist" = disk "ext4" "9ff01eeb-f39f-4aca-ab09-aac809b10669";
    "/home"    = disk "ext4" "6928d06b-9c7c-4526-8094-7a49f3d209ea";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/4f051bca-6f65-4bf8-903a-183575b6b3ae"; } ];

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "usbhid" "usb_storage" "sd_mod" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
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
