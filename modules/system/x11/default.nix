{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.custom.x11;

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
    services.xserver = {
      enable = true;

      displayManager = {
        autoLogin.enable = false;
        autoLogin.user = cfg.autoLoginUser;
        lightdm.enable = true;
        #sddm.enable = true;
      };

      windowManager.bspwm = {
        enable = true;
        configFile = ../../../assets/bspwmrc;
        sxhkd.configFile = import ./sxhkdrc.nix { inherit pkgs; };
      };
      displayManager.defaultSession = "none+bspwm";

      # mouse/touchpad
      # --------------
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
          tapping = true;
          scrollMethod = "twofinger";
          accelSpeed = "2";
        };
      };
    };

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
      shared_mime_info

      hunspell
      hunspellDicts.en-us
    ];

    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
      dbus.enable = true;
      autorandr.enable = true;
      picom.enable = true;
    };

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
