{ lib, config, pkgs, ... }: {
  imports = [
    # TODO: choose a grub theme?
    #./grub.nix
    ./programs.nix
    ./sshd-known-hosts-private.nix
    ./sshd-known-hosts-public.nix
    ./syncthing.nix
  ];

  #TODO: use predicate
  nixpkgs.config.allowUnfree = true;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  # some system stuff
  # -----------------
  time.timeZone = lib.mkDefault "America/Chicago";

  #TODO: change locale
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # keyboard fiddling
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";
  services.xserver.layout = "us";
}
