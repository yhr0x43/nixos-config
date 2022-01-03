{ config, lib, pkgs, hardware, home-manager, ... }:

with lib;

let

  cfg = config.profile.workstation;

in {
  options.profile.workstation = {
    enable = mkEnableOption "enable workstation profile";
  };

  config = mkIf cfg.enable {
    profile.desktop.enable = true;

    services.openssh = {
      enable = true;
      forwardX11 = true;
      passwordAuthentication = false;
    };

    programs.light.enable= true;

    services.flatpak.enable = true;
    xdg.portal.enable = true;
    xdg.portal.gtkUsePortal = true;
    xdg.portal.extraPortals =
      [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

    # Needed for steam and many games.
    hardware.opengl.driSupport32Bit = true;
    hardware.pulseaudio.support32Bit = true;

    # For Dualshock 3 support
    hardware.bluetooth.package = pkgs.bluezFull;

    environment.systemPackages = with pkgs; [
      openconnect
      usbutils
      imagemagick
      libnotify
      gimp-with-plugins

      hackrf
    ];

    services.deluge = {
      enable = true;
      web.enable = true;
    };

    services.picom.enable = true;

    services.xserver.wacom.enable = true;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.mainUser = import ../../home.nix;
  };
}
