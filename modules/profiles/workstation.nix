{ config, lib, pkgs, hardware, ... }:

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
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
    };

    # services.flatpak.enable = true;
    # xdg.portal.enable = true;
    # xdg.portal.gtkUsePortal = true;
    # xdg.portal.extraPortals =
    #   [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];

    virtualisation.lxd.enable = true;
    virtualisation.lxc.lxcfs.enable = true;
    system.custom.mainUser.extraGroups = [ "lxd" ];

    hardware.graphics.enable32Bit = true;
    hardware.pulseaudio.support32Bit = true;

    environment.systemPackages = with pkgs; [
      hackrf
    ];

    services.deluge = {
      enable = true;
      web.enable = true;
    };

    services.xserver.wacom.enable = true;
  };
}
