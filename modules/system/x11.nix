{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.custom.x11;

in {

  options.system.custom.x11 = {
    enable = mkEnableOption "enable x11";
    autoLoginUser = mkOption {
      type = with types; str;
      description = "user to login";
    };
  };

  config = mkIf cfg.enable {
    #TODO: many configs here aren't necessarily relate to 'X' per se.
    # (dbus, libinput, and wm stuff: bspwm, polybar, sxhkd) 

    services.xserver = {

      enable = true;

      # Configure video Drivers
      # -----------------------
      #videoDrivers = [ "intel" ];
      #deviceSection = ''
      #  Option "DRI" "2"
      #  Option "TearFree" "true"
      #'';

      # window-manager : bspwm
      windowManager.bspwm.enable = true;

      # mouse/touchpad
      # --------------
      libinput = {
        enable = true;
        disableWhileTyping = true;
        tapping = true;
        scrollMethod = "twofinger";
        accelSpeed = "2";
      };
    };

    systemd.user.services.polybar = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.polybar}/bin/polybar default"; 
        ExecReload = "/usr/bin/kill -SIGUSR1 $MAINPID";
      };
    };

    services.dbus.enable = true;

    # Packages
    # --------
    environment.systemPackages = with pkgs; [

      alacritty
      dmenu
      dunst
      flameshot
      polybar
      sxhkd
      #feh

    ];

    # Xresources config
    # -----------------
    # spread the Xresource config
    # across different files
    # just add a file into `/etc/X11/Xresource.d/` and it will be
    # evaluated.
    services.xserver.displayManager.sessionCommands = ''
      for file in `ls /etc/X11/Xresource.d/`
      do
        ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresource.d/$file
      done
    '';

    environment.etc."/X11/Xresource.d/.keep".text = "";

  };
}

