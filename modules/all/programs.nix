{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Archive
    unar zip unzip

    binutils
    file
    htop
    killall
    lsof

    wget curl

    # Nix-specific tools
    #appimage-run
    nix-index
    patchelf
    #unstable.cachix
    #unstable.nix-tree
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 150000;
    secureSocket = true;
  };

}

