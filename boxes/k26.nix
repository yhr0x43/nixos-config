{ lib, pkgs, ... }:

{
  system.custom.fs.enable = true;
  system.custom.fs.bootUuid = "";

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
  networking.hostId = "8dcfb167";

  hardware.enableRedistributableFirmware = true;
}
