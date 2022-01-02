{ lib, pkgs, ... }:

{
  system.custom.fs.bootUuid = "0A5E-C2D1";
  system.custom.bluetooth.enable = true;

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
