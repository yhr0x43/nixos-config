{ config, pkgs, ... }:

{

  imports = [
    ./all

    ./profiles/desktop.nix
    ./profiles/workstation.nix
    ./profiles/gaming.nix

    ./networking/wireguard.nix

    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/font.nix
    ./system/fs.nix
    ./system/i18n.nix
    ./system/mainUser.nix
    ./system/syncthing.nix
    ./system/udev.nix
    ./system/x11
    ./system/x11/stumpwm-wrapper.nix

    ./virtualisation/vfio.nix
    ./virtualisation/libvirt.nix
  ];

}
