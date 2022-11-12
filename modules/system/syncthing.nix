{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.syncthing;

in {
  options.system.custom.syncthing = {
    enable = mkEnableOption "custom sycthing configs";

    customUser.enable = mkEnableOption ''run syncthing as system.custom.mainUser'';
  };

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
          "5HN4Z3U-XLLX7OX-O7K2WDG-KNZBBWF-MVXJFKR-SRWHYNO-3BFEHVY-Z3HXFQ7")
        // (device "tpx1c"
          "7RHVCK4-ZPK6ITD-HES2N4M-LKW3NBV-S4T5257-Z3SWJPJ-F47VKCO-WHQWCAN")
        // (device "cybermega"
          "P6ZS6XU-AUHWG7S-BJTFDEO-ABPDFLA-YBWB2T2-XV52M7D-NVZAYAE-IWFT3QJ")
        // (device "frame"
          "GUUZEKH-NI3B4QI-7GTMJ4L-FUGDEDF-TWGGKND-7PT6DWY-ZOXTVTA-4WDIXQV")
        ;

        folders = {
          dox = {
            enable = mkDefault false;
            id = "rfkc3-ae2wq";
            devices = [ "k26" "tpx1c" "cybermega" "frame" ];
          };
          pass = {
            enable = mkDefault false;
            id = "nmdgd-nr5ik";
            devices = [ "k26" "tpx1c" "cybermega" "frame" ];
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
