{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.audio;

in {

  options.system.custom.audio = {
    enable = mkEnableOption "use PluseAudio";
  };

  config = mkIf cfg.enable {
    # because of systemWide ensure main user is in audio group
    #system.custom.mainUser.extraGroups = [ "audio" ];

    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;

      # all in audio group can do audio
      # systemWide = true;

      extraConfig = ''
        # automatically switch to newly-connected devices
        load-module module-switch-on-connect
      '';
    };

    nixpkgs.config.pulseaudio = true;

    # Packages needed
    # ---------------
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}

