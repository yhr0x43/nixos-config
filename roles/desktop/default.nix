{ pkgs, ... }: {

  imports = [
    ../all
    ./fonts.nix
    ./syncthing.nix
    ./xserver.nix
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

  system.custom.mainUser = {
    enable = true;
    userName = "yhrc";
    extraGroups = [ "wireshark" "video" "lp" "scanner" ];
  };
  #users.users.yhrc = rec {
  #  name = "yhrc";
  #  shell = pkgs.zsh;
  #  home = "/home/${name}";
  #  isNormalUser = true;
  #  extraGroups = [ "wheel" "lp" "scanner" "libvirtd" "video" "networkmanager" ];
  #};

}
