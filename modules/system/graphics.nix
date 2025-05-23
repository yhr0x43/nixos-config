{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.custom.graphics;

in {
  options.system.custom.graphics = {
    enable = mkEnableOption "Common graphics options for a system with GUI";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable = true;
    environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];
    programs.light.enable = true;
  };
}
