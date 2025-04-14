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
    
    system.custom.mainUser.extraGroups = [ "audio" ];

    # Audio Management Tools
    # ---------------
    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  };
}

