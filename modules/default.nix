{ config, pkgs, ... }:

{

  imports = [
    ./all

    ./hardware/amd.nix

    ./profiles/desktop
    ./profiles/workstation.nix
    ./profiles/gaming.nix

    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/font.nix
    ./system/fs.nix
    ./system/i18n.nix
    ./system/mainUser.nix
    ./system/syncthing.nix
    ./system/udev.nix
    ./system/x11

    ./virtualisation/vfio.nix
    ./virtualisation/libvirt.nix
  ];

}
