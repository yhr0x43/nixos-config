{ lib, pkgs, ... }:

{
  imports = [ ./common/zfs.nix ./common/udev.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0A5E-C2D1";
    fsType = "vfat";
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  nix.maxJobs = lib.mkDefault 24;

  services.xserver.wacom.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General.AutoConnect = true;
      Policy.AutoEnable = true;
    };
  };

  services.blueman.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;

    extraConfig = ''
      # automatically switch to newly-connected devices
      load-module module-switch-on-connect
    '';
  };

  # HackRF configs, hand written rules to not use plugdev
  environment.systemPackages = with pkgs; [
    hackrf
  ];

  nixpkgs.config.pulseaudio = true;
}
