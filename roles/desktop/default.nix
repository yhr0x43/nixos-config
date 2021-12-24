{ pkgs, ... }: {

  imports = [
    ../all
    ./fonts.nix
    ./syncthing.nix
    ./xserver.nix
    ./i18n.nix
  ];

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

  services.tumbler.enable = true;
}
