{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.system.custom.mainUser;

  #TODO: predicate when to include "wireshark", "video", "lp", "scanner"
  groupConfigs = lib.filterAttrs (n: v: v) {
    "docker" = config.virtualisation.docker.enable;
    "vboxusers" = config.virtualisation.virtualbox.host.enable;
    "libvirtd" = config.virtualisation.libvirtd.enable;
    "networkmanager" = config.networking.networkmanager.enable;
  };
in {

  options.system.custom.mainUser = {

    enable = mkEnableOption "enable mainUser for a desktop system";

    userName = mkOption {
      type = with types; str;
      description = ''
        name of the main user
      '';
    };

    uid = mkOption {
      type = with types; int;
      default = 1000;
      description = ''
        uid of main user
      '';
    };

    extraGroups = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = ''
        list of groups the main user should also be in
      '';
    };

    authorizedKeyFiles = mkOption {
      default = [ ];
      type = with types; listOf str;
      description = ''
        list of keys allowed to login as this user
      '';
    };

  };

  config = mkIf cfg.enable {

    #FIXME shell should not be specified here
    programs.zsh.enable = true;
    users = {

      mutableUsers = true;
      defaultUserShell = pkgs.bash;

      users.mainUser = {
        shell = pkgs.zsh;
        name = cfg.userName;
        uid = cfg.uid;
        initialPassword = cfg.userName;
        home = "/home/${cfg.userName}";
        isNormalUser = true;
        extraGroups = [ "wheel" ]
          ++ lib.mapAttrsToList (n: v: n) groupConfigs
          ++ cfg.extraGroups;
        openssh.authorizedKeys.keyFiles = cfg.authorizedKeyFiles;
      };
    };
  };
}
