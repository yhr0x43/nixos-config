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
        #FIXME: fcitx5 seems not working with alacritty, relegated to using XWayland
        (writeShellScriptBin "alacritty" ''WINIT_UNIX_BACKEND=x11 ${pkgs.alacritty}/bin/alacritty "$@"'')
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
    };

    xdg.portal.wlr.enable = true;

    environment.etc = {
      "sway/config.d" = {
        "/10-systemd".text = ''
          exec "systemctl --user import-environment; systemctl --user start sway-session.target"
        '';

        "90-outputs.conf".text = ''
          output HDMI-A-1 mode 3840x2160 pos 0 0
          output DP-1 mode 1920x1080 pos 1920 2160
          output DP-2 disable
        '';
      };
    };

    programs.qt5ct.enable = true;

    environment.systemPackages = with pkgs; [
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
      # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
      (writeShellScriptBin "startsway" ''
        # first import environment variables from the login manager
        systemctl --user import-environment
        # then start the service
        exec systemctl --user start sway.service
      '')
    ];

    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = [ "man:sway(5)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway"
        #+ " --debug"
        ;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    programs.waybar.enable = true;

    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = let
          kanshi-config = (pkgs.writeText "kanshi-config" ''
              profile {
                output HDMI-A-1 mode 3840x2160 position 0,0
                output DP-1 mode 1920x1080 position 1920,2160
                output DP-2 disable
              }
          '');
        in
          ''
            ${pkgs.kanshi}/bin/kanshi --config ${kanshi-config}
          '';
        RestartSec = 5;
        Restart = "always";
      };
    };

    systemd.user.services.swayidle = {
      description = "Idle Manager for Wayland";
      documentation = [ "man:swayidle(1)" ];
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStart = ''${pkgs.swayidle}/bin/swayidle -w -d \
          timeout 300 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
          resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
        '';
      };
    };
  };
}
