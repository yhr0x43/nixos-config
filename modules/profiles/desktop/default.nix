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

    system.custom.audio.enable = true;

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
      extraGroups = [ "wireshark" "video" "lp" "scanner" "dialout" "deluge" ];
    };

    time.timeZone = "America/Chicago";

    environment.systemPackages = with pkgs; [
      python3 # for passFF
      pavucontrol

      zoom-us
      teams
    ];

    #TODO: use u2f
    security.pam.yubico = {
      enable = true;
      mode = "challenge-response";
    };

    # Running GNOME program outside of GNOME
    # Provide Dbus ca.desrt.dconf
    programs.dconf.enable = true;

    environment.variables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      #GNUPGHOME = "~/.local/share/gnupg";
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.pcscd.enable = true;
    services.avahi.enable = true;

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
