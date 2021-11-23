{ lib, config, pkgs, ... }:

let

  cfg = config.profile.x11;
  unstable = import <nixos-unstable> {};
  inherit (lib) optionals;

in {
  imports = [
    ../services/gpg.nix
  ];

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  # Explicit PulseAudio support in applications
  nixpkgs.config.pulseaudio = true;

  hardware.bluetooth.enable = true;

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    #libinput.enable = true; #TODO What does libinput do exactly?
  };

  services.picom = {
    enable = false;
    #TODO picom config
  };

  services.dbus.enable = true;

  environment.systemPackages = with pkgs; [
    polybar
    firefox
    flameshot
    dunst
    pavucontrol
    dmenu
    libnotify
    zathura
    alacritty
    libreoffice
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];


  systemd.user.services = {
    polybar = {
      description = "Polybar";
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.polybar}/bin/polybar default"; 
        ExecReload = "/usr/bin/kill -SIGUSR1 $MAINPID";
      };
    };

    flameshot = {
      description = "Flameshot";
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.flameshot}/bin/flameshot"; 
      };
    };
  };

  services.blueman.enable = true;

  services.syncthing = {
    enable = true;
    user = "yhrc";
    dataDir = "/home/yhrc";
    configDir = "/home/yhrc/.config/syncthing";
    declarative.folders = {
      "/home/yhrc/dox"                        .id = "rfkc3-ae2wq";
      "/home/yhrc/.local/share/password-store".id = "nmdgd-nr5ik";
    };
  };

  services.pcscd.enable = true;

  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
