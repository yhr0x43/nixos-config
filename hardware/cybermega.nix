{ lib, pkgs, ... }:

{
  imports = [ ./common/zfs.nix ./common/udev.nix ];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0A5E-C2D1";
    fsType = "vfat";
  };

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

  nixpkgs.config.pulseaudio = true;

  # HackRF configs, hand written rules to not use plugdev
  environment.systemPackages = with pkgs; [
    hackrf
  ];
}
