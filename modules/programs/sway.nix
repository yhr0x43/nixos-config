{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.custom.sway;

in {
  options.programs.custom.sway = {
    enable = mkEnableOption "enable wayland";
  };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        mako # notification daemon
        alacritty # Alacritty is the default terminal in the config
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
    };

    xdg.portal.wlr.enable = true;

    environment.etc."sway/config.d/monitor.conf".source = pkgs.writeText "monitor.conf" ''
      output HDMI-A-1 mode 3840x2160 pos 0 0
      output DP-1 mode 1920x1080 pos 1920 2160
      output DP-2 disable
    '';

    programs.qt5ct.enable = true;

    environment.systemPackages = with pkgs; [
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
    ];
  };
}
