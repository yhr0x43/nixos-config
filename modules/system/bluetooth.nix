{ config, lib, pkgs, ... }:

let

  cfg = config.system.custom.bluetooth;

in {

  options.system.custom.bluetooth.enable =
    lib.mkEnableOption "enable bluetooth support";

  config = lib.mkIf cfg.enable {

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      config.General.AutoConnect = true;
    };

    services.blueman.enable = true;

    environment.systemPackages = with pkgs; [

      # bluetooth audio
      # ---------------
      # todo : check if pulseaudio is enabled
      bluez
      bluez-tools

    ];
  };

}

