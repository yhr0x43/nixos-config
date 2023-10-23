{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.custom.sway;

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };

in {
  options.programs.custom.sway = { enable = mkEnableOption "enable wayland"; };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        alacritty
        sway
        dbus-sway-environment
        wayland
        configure-gtk
        swaylock
        swayidle
        wl-clipboard
        xdg-utils # for openning default programms when clicking links
        glib # gsettings
        bemenu # wayland clone of dmenu
        mako # notification daemon
        #FIXME: fcitx5 seems not working with alacritty, relegated to using XWayland
        #(writeShellScriptBin "alacritty" ''WINIT_UNIX_BACKEND=x11 ${pkgs.alacritty}/bin/alacritty "$@"'')
        #dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
    };
    
    services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    };
    services.dbus.enable = true;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.etc = {
      #"sway/config.d/10-systemd".text = ''
      #  exec "systemctl --user import-environment; systemctl --user start sway-session.target"
      #'';

      "sway/conf.d/20-sway-config".text = ''
        set $menu bemenu-run

        # screenshots
        bindsym $mod+c exec grim  -g "$(slurp)" /tmp/$(date +'%H:%M:%S.png')


        exec dbus-sway-environment
        exec configure-gtk
      '';

      "sway/config.d/90-outputs.conf".text = ''
        output HDMI-A-1 mode 3840x2160 pos 0 0
        output DP-1 mode 1920x1080 pos 1920 2160
        output DP-2 disable

        output eDP-1 mode 2256x1504 pos 0 0
      '';
    };

    qt.platformTheme = "qt5ct";

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

    # systemd.user.targets.sway-session = {
    #   description = "Sway compositor session";
    #   documentation = [ "man:systemd.special(7)" ];
    #   bindsTo = [ "graphical-session.target" ];
    #   wants = [ "graphical-session-pre.target" ];
    #   after = [ "graphical-session-pre.target" ];
    # };

    # systemd.user.services.sway = {
    #   description = "Sway - Wayland window manager";
    #   documentation = [ "man:sway(5)" ];
    #   bindsTo = [ "graphical-session.target" ];
    #   wants = [ "graphical-session-pre.target" ];
    #   after = [ "graphical-session-pre.target" ];
    #   # We explicitly unset PATH here, as we want it to be set by
    #   # systemctl --user import-environment in startsway
    #   environment.PATH = lib.mkForce null;
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway"
    #       #+ " --debug"
    #     ;
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };

    programs.waybar.enable = true;

    # systemd.user.services.kanshi = {
    #   description = "Kanshi output autoconfig ";
    #   wantedBy = [ "graphical-session.target" ];
    #   partOf = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     ExecStart = let
    #       kanshi-config = (pkgs.writeText "kanshi-config" ''
    #         profile {
    #           output HDMI-A-1 mode 3840x2160 position 0,0
    #           output DP-1 mode 1920x1080 position 1920,2160
    #           output DP-2 disable
    #         }
    #       '');
    #     in ''
    #       ${pkgs.kanshi}/bin/kanshi --config ${kanshi-config}
    #     '';
    #     RestartSec = 5;
    #     Restart = "always";
    #   };
    # };

    systemd.user.services.swayidle = {
      description = "Idle Manager for Wayland";
      documentation = [ "man:swayidle(1)" ];
      wantedBy = [ "sway-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = [ pkgs.bash ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.swayidle}/bin/swayidle -w -d \
                    timeout 300 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
                    resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
        '';
      };
    };
  };
}
