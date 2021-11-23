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
  networking.networkmanager.enable = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.hostName = "tpx1c";
  networking.hostId = "aa222655";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;
}
