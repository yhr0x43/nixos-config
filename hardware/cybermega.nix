{ lib, pkgs, ... }:

{
  imports = [ ./common/zfs.nix ];

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

  services.udev.extraRules = ''
    # HackRF Jawbreaker
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="604b", SYMLINK+="hackrf-jawbreaker-%k", MODE="660", TAG+="uaccess"
    # HackRF One
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", MODE="660", TAG+="uaccess"
    # rad1o
    ATTR{idVendor}=="1d50", ATTR{idProduct}=="cc15", SYMLINK+="rad1o-%k", MODE="660", TAG+="uaccess"
    # NXP Semiconductors DFU mode (HackRF and rad1o)
    ATTR{idVendor}=="1fc9", ATTR{idProduct}=="000c", SYMLINK+="nxp-dfu-%k", MODE="660", TAG+="uaccess"
    # rad1o "full flash" mode
    KERNEL=="sd?", SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="1fc9", ENV{ID_MODEL_ID}=="0042", SYMLINK+="rad1o-flash-%k", MODE="660", TAG+="uaccess"
    # rad1o flash disk
    KERNEL=="sd?", SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="1fc9", ENV{ID_MODEL_ID}=="0082", SYMLINK+="rad1o-msc-%k", MODE="660", TAG+="uaccess"
    #
  '';

  nixpkgs.config.pulseaudio = true;
}
