{ lib, config, pkgs, ... }:

let

  cfg = config.profile.desktop;

in {
  options.profile.desktop = {
    enable = mkEnableOption "Turn on desktop profile";
  };

  config = mkIf cfg.enable {
    system.custom = {
      fonts.enable = true;
      i18n.enable = true;
      syncthing.enable = true;
    };

    time.timeZone = "America/Chicago";

    environment.systemPackages = with pkgs; [
      python3 #TODO: for passFF
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

      #TODO: more proper home-cleanup
      IPYTHONDIR = "$XDG_CONFIG_HOME/jupyter";
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    };

    system.custom.mainUser = {
      enable = true;
      userName = "yhrc";
      #TODO: manage wireshark in system.custom.mainUser
      extraGroups = [ "wireshark" "video" "lp" "scanner" "dialout" ];
    };
  };
}
