{ config, lib, pkgs, ... }:

with lib;

{
  imports =
    [
      ./i18n.nix
    ];

  boot.tmpOnTmpfs = lib.mkDefault true;
  boot = {
    supportedFilesystems = [ "ntfs" "zfs" ];

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        version = 2;
        devices = [ "nodev" ];
      };
    };
  };

  services.printing.enable = true;

  # nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl wget file lsof
    gitAndTools.gitFull
    unzip zip unrar p7zip dtrx
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  users.extraUsers.yhrc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" ];
  };

  services.syncthing = {
    enable = true;
    user = "yhrc";
    dataDir = "/home/yhrc";
    configDir = "/home/yhrc/.config/syncthing";
    declarative = {
      folders = {
        "/home/yhrc/dox" = {
          id = "rfkc3-ae2wq";
          devices = [ "k26" ];
        };
        "/home/yhrc/.password-store" = {
          id = "nmdgd-nr5ik";
          devices = [ "k26" ];
        };
      };
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };
}

