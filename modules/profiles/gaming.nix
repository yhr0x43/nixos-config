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
      wine
      (lowPrio wineWowPackages.full)
      discord
      steam-run-native
      mumble
    ];

    programs.steam.enable = true;
  };
}
