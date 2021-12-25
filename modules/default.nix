{ config, pkgs, ... }:

{

  imports = [
    ./all

    ./hardware/amd.nix

    ./profiles/desktop.nix

    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/font.nix
    ./system/i18n.nix
    ./system/mainUser.nix
    ./system/syncthing.nix
    ./system/x11.nix

    ./virtualisation/vfio.nix
    ./virtualisation/libvirt.nix
  ];

}
