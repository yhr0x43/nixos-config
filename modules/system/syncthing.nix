{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.syncthing;

in {
  options.system.custom.syncthing = {
    enable = mkEnableOption "custom sycthing configs";

    customUser.enable = mkEnableOption ''run syncthing as system.custom.mainUser'';
  };

  #FIXME: this is too hacky (is recursiveUpdate mkIfs the way to do it?)
  config = mkMerge [
    (mkIf cfg.enable {
      services.syncthing = {
        enable = true;
        cert = toString ../../secrets/syncthing/cert.pem;
        key = toString ../../secrets/syncthing/key.pem;

        overrideDevices = true;
        devices = let
          device = name: id: {
            "${name}" = {
              name = name;
              id = id;
              #addresses =
              #  [ "tcp://${name}.private:22000" "tcp://${name}.private:21027" ];
            };
          };
        in (device "k26"
          "A6U3CEA-2UV6CKO-BCAUZYI-P6VQ76M-GQ33Q43-GSDTVBA-R7FBINT-TRGU6QP")
        // (device "tpx1c"
          "7RHVCK4-ZPK6ITD-HES2N4M-LKW3NBV-S4T5257-Z3SWJPJ-F47VKCO-WHQWCAN")
        // (device "cybermega"
          "P6ZS6XU-AUHWG7S-BJTFDEO-ABPDFLA-YBWB2T2-XV52M7D-NVZAYAE-IWFT3QJ")
        // (device "nut"
          "QWAOM3H-TQ75QDG-QCXH4O5-5MUV7XX-TYLU5NI-W443RHC-K6YU3QD-72V52AD")
        ;

        folders = {
          dox = {
            enable = mkDefault false;
            id = "rfkc3-ae2wq";
            devices = [ "k26" "tpx1c" "cybermega" ];
          };
          pass = {
            enable = mkDefault false;
            id = "nmdgd-nr5ik";
            devices = [ "k26" "tpx1c" "cybermega" "nut" ];
          };
        };
      };
    })
    (mkIf cfg.customUser.enable {
      services.syncthing = {
        # use home-manager to launch in user session
        systemService = false;

        user = config.system.custom.mainUser.userName;
        group = "users";
        dataDir = config.users.users.mainUser.home;
        configDir = "${config.users.users.mainUser.home}/.config/syncthing";
      };
    })
  ];
}
