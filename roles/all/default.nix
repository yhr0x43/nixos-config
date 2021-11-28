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
  ];

  time.timeZone = lib.mkDefault "America/Chicago";

  #TODO: change locale
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # keyboard fiddling
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  services.xserver.layout = "us";
}
