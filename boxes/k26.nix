{ lib, pkgs, ... }:

{
  system.custom.fs.enable = true;
  system.custom.fs.bootUuid = "0A5E-C2D1";

  boot = {
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
    #kernelModules = [ "kvm-amd" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];
      };
    };
  };

  nix.maxJobs = 32;

  networking.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  #networking.interfaces.enp8s0.useDHCP = true;

  networking.hostName = "k26";
  networking.hostId = "6964344f";

  hardware.enableRedistributableFirmware = true;
}
