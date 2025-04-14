{ lib, config, pkgs, ... }: {
  imports = [
    # TODO: choose a grub theme?
    #./grub.nix
    ./programs.nix
    ./sshd-known-hosts-private.nix
    ./sshd-known-hosts-public.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "minecraft-launcher"
    "discord"
    "corefonts"
    "cnijfilter"
    "cnijfilter2"
    "teams"
    "zoom"
  ];

  # keyboard fiddling
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  services.xserver.xkb.layout = "us";
}
