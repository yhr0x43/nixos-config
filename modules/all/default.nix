{ lib, config, pkgs, ... }: {
  imports = [
    # TODO: choose a grub theme?
    #./grub.nix
    ./programs.nix
    ./sshd-known-hosts-private.nix
    ./sshd-known-hosts-public.nix
    ./syncthing.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "minecraft-launcher"
    "discord"
    "corefonts"
    "zoom"
  ];

  time.timeZone = lib.mkDefault "America/Chicago";

  i18n = {
    defaultLocale = lib.mkDefault "ja_JP.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
  };

  # keyboard fiddling
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  services.xserver.layout = "us";
}
