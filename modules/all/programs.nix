{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Archive
    unar zip unzip

    # Unix Tools
    binutils
    file
    htop
    killall
    lsof
    screen
    ed
    bc

    wget
    curl

    # Nix-specific tools
    #appimage-run
    nix-index
    patchelf
    cachix
    #unstable.nix-tree
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 150000;
    secureSocket = true;
  };

}

