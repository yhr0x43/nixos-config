{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.audio;

in {

  options.system.custom.audio = {
    enable = mkEnableOption "use audio";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };



    # because of systemWide ensure main user is in audio group
    #system.custom.mainUser.extraGroups = [ "audio" ];

    #hardware.pulseaudio = {
    #  enable = true;
    #  package = pkgs.pulseaudioFull;

    #  # all in audio group can do audio
    #  # systemWide = true;

    #  extraConfig = ''
    #    # automatically switch to newly-connected devices
    #    load-module module-switch-on-connect
    #  '';
    #};

    #nixpkgs.config.pulseaudio = true;

    # Packages needed
    # ---------------
    #TODO: maybe tryout more interesting tools?
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}

