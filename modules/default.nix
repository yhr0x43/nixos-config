{ config, pkgs, ... }:

{

  imports = [
    ./all

    ./hardware/amd.nix

    ./system/audio.nix
    ./system/bluetooth.nix
    ./system/font.nix
    ./system/mainUser.nix
    ./system/x11.nix

    ./virtualisation/vfio.nix
    ./virtualisation/libvirt.nix
  ];

}
