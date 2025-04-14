{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.custom.x11;
  stumpwm-wrapper = (pkgs.callPackage ./stumpwm-wrapper.nix { });

in {

  options.system.custom.x11 = {
    enable = mkEnableOption "enable x11";
    autoLoginUser = mkOption {
      type = types.str;
      default = config.system.custom.mainUser.userName;
      description = "user to login";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager = {
      autoLogin = {
        enable = false;
        user = cfg.autoLoginUser;
      };
      # defaultSession = if config.programs.custom.sway.enable then "sway" else "none+bspwm";
      defaultSession = "none+bspwm";
    };
    services.xserver = {
      enable = true;

      displayManager = {
        lightdm.enable = true;
      };

      # windowManager.stumpwm.enable = true;
      # windowManager.stumpwm-wrapper.enable = true;

      windowManager.bspwm = {
        enable = true;
        configFile = ../../../assets/bspwmrc;
        sxhkd.configFile = import ./sxhkdrc.nix { inherit pkgs; };
      };
    };

    services.libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        tapping = true;
        scrollMethod = "twofinger";
        accelSpeed = "2";
      };
    };

    services.touchegg.enable = true;

    environment.systemPackages = with pkgs; [
      flameshot

      (xfce.thunar.override {
        thunarPlugins = [
          xfce.thunar-volman
        ];
      })
      xfce.xfconf
      calcurse
      gnome.adwaita-icon-theme
      hicolor-icon-theme
      lxappearance
      lxmenu-data
      shared-mime-info

      (hunspellWithDicts (with hunspellDicts; [ en-us ]))
    ];

    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
      dbus.enable = true;
      autorandr.enable = true;
    };

    # services.picom = {
    #   enable = true;
    #   backend = "xr_glx_hybrid";
    #   fade = true;
    #   vSync = true;
    # };

    # Xresources config
    # -----------------
    # spread the Xresource config across different files
    # just add a file into `/etc/X11/Xresource.d/` and it will be evaluated.
    #services.xserver.displayManager.sessionCommands = ''
    #  for file in `ls /etc/X11/Xresource.d/`
    #  do
    #    ${pkgs.xorg.xrdb}/bin/xrdb -merge /etc/X11/Xresource.d/$file
    #  done
    #'';

    #environment.etc."/X11/Xresource.d/.keep".text = "";
  };
}
