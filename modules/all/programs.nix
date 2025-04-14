{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Archive
    unar zip unzip p7zip

    # Unix Tools
    binutils
    file
    htop
    killall
    lsof
    screen
    ed
    bc
    jq

    wget
    curl
    acpi

    man-pages
    man-pages-posix

    # Nix-specific tools
    #appimage-run
    nix-index
    patchelf
    cachix
    #unstable.nix-tree
  ];
  
  documentation.dev.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 150000;
    secureSocket = true;
  };

}

