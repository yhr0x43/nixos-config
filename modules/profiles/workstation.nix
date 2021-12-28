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
    ];

    services.avahi.enable = true;

    services.deluge = {
      enable = true;
      web.enable = true;
    };

    services.pcscd.enable = true;

    #Enable CUPS to print documents.
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      gutenprint
      gutenprintBin
    ];

    hardware.sane.enable = true;

    services.picom.enable = true;
    services.upower.enable = true;

    services.dbus.enable = true;

    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.users.mainUser = import ../../home.nix;

    nix.trustedUsers = [ config.system.custom.mainUser.userName ];

    # Way too annoying to manage on a desktop system IMHO
    networking.firewall.enable = false;
  };
}
