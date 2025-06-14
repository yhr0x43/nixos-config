{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.profile.desktop;

in {
  options.profile.desktop = {
    enable = mkEnableOption "enable desktop profile";
  };

  config = mkIf cfg.enable {
    system.custom.bluetooth.enable = true;
    system.custom.fonts.enable = true;
    
    system.custom.audio.enable = true;
    system.custom.graphics.enable = true;

    system.custom.udev = {
      hackRF = true;
      ATmega32U4 = true;
      dsLogic = true;
    };

    system.custom.i18n.enable = true;

    qt.platformTheme = "qt5ct";
    security.polkit.enable = true;

    system.custom.mainUser = {
      enable = true;
      userName = "yhrc";
      #TODO: manage wireshark in system.custom.mainUser
      extraGroups = [ "wireshark" "video" "lp" "scanner" "dialout" "deluge" "input" "render" ];
    };
    
    programs.less = {
      enable = true;
      envVariables = {
        # X = leave content on-screen
        # F = quit automatically if less than one screenfull
        # R = raw terminal characters (fixes git diff)
        #     see http://jugglingbits.wordpress.com/2010/03/24/a-better-less-playing-nice-with-git/
        LESS = "-FXR";
        # colored man output
        # from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
        LESS_TERMCAP_mb = "[01;31m"; # begin blinking
        LESS_TERMCAP_md = "[01;38;5;74m"; # begin bold
        LESS_TERMCAP_me = "[0m"; # end mode
        LESS_TERMCAP_se = "[0m"; # end standout-mode
        LESS_TERMCAP_so = "[38;5;246m"; # begin standout-mode - info box
        LESS_TERMCAP_ue = "[0m"; # end underline
        LESS_TERMCAP_us = "[04;38;5;146m"; # begin underline
      };
    };

    environment.systemPackages = with pkgs; [
      hicolor-icon-theme

      python3 # for passFF
      pavucontrol

      # gtk libraries
      # FIXME: No schema installed
      glib # gsettings
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
      lxmenu-data
      shared-mime-info
      
      # NONFREE
      # zoom-us
      # teams
    ];

    #TODO: does re-implementing the services here make sense?
    # Especiall the project has default ones: https://github.com/maximbaz/yubikey-touch-detector
    systemd.user.services."yubikey-touch-detector" = {
      description = "Detects when your YubiKey is waiting for a touch";
      requires = [ "yubikey-touch-detector.socket" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector";
        EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
      };
    };

    systemd.user.sockets."yubikey-touch-detector" = {
      description = "Detects when your YubiKey is waiting for a touch";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "%t/yubikey-touch-detector.socket" ];
      socketConfig.RemoveOnStop = "yes";
    };

    security.pam.u2f.enable = true;

    # Running GNOME program without GNOME
    # Provide Dbus ca.desrt.dconf
    programs.dconf.enable = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    services = {
      pcscd.enable = true;
      avahi.enable = true;
      udisks2.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
      dbus.enable = true;
    };

    hardware.sane.enable = true;
    #Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ gutenprint gutenprintBin ];

    nix.settings.trusted-users = [ config.system.custom.mainUser.userName ];

    networking.firewall.enable = false;
  };
}
