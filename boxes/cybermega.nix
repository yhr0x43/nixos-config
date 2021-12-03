{ lib, ... }: {

  imports = [ ../roles/workstation.nix ../roles/gaming.nix ../hardware/cybermega.nix ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];

        # https://nixos.wiki/wiki/NixOS_on_ZFS
        copyKernels = true;
      };
    };
  };

  networking.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;

  networking.hostName = "cybermega";
  networking.hostId = "6964344f";

  # Needed so that nixos-hardware enables CPU microcode updates
  hardware.enableRedistributableFirmware = true;
}
