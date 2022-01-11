{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.profile.gaming;

in {
  options.profile.gaming = {
    enable = mkEnableOption "enable gaming profile";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      multimc
      minecraft
      flite              # For Minecraft TTS
      discord
      steam-run-native
      mumble
      lutris
    ];

    programs.steam.enable = true;
  };
}
