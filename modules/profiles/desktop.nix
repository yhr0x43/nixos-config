{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.profile.desktop;

in {
  options.profile.desktop = {
    enable = mkEnableOption "enable desktop profile";
  };

  config = mkIf cfg.enable {
    system.custom.fonts.enable = true;
    system.custom.syncthing = {
      enable = true;
      customUser.enable = true;
    };

    services.syncthing = {
      folders = {
        dox = {
          enable = true;
          path = "/home/yhrc/dox";
        };
        pass = {
          enable = true;
          path = "/home/yhrc/.local/share/password-store";
        };
      };
    };

    system.custom.udev = {
      hackRF = true;
      ATmega32U4 = true;
    };

    system.custom.x11.enable = true;
    system.custom.i18n.enable = true;

    system.custom.mainUser = {
      enable = true;
      userName = "yhrc";
      #TODO: manage wireshark in system.custom.mainUser
      extraGroups = [ "wireshark" "video" "lp" "scanner" "dialout" ];
    };

    time.timeZone = "America/Chicago";

    environment.systemPackages = with pkgs; [
      python3 # for passFF
      pavucontrol

      # WM relavent derivation
      dmenu
      flameshot
      j4-dmenu-desktop

      xfce.thunar
      lxmenu-data
      shared_mime_info

      # Archive manager
      mate.engrampa

      hunspell
      hunspellDicts.en-us
    ];

    #TODO: use u2f
    security.pam.yubico = {
      enable = true;
      mode = "challenge-response";
    };

    # Auto-mount USB drive
    services.gvfs.enable = true;

    # Running GNOME program outside of GNOME
    # Provide Dbus ca.desrt.dconf
    programs.dconf.enable = true;

    environment.variables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
    };

    services.tumbler.enable = true;

    services.upower.enable = true;

    services.dbus.enable = true;

    services.avahi.enable = true;

    services.pcscd.enable = true;

    hardware.sane.enable = true;

    #Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];

    nix.trustedUsers = [ config.system.custom.mainUser.userName ];
  };
}
