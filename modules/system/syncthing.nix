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
        settings.devices = let
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
          "PBCMGCQ-C5K5S7F-HERVNJU-UG2M4EV-TCHOADU-3YFNCBB-F275BDY-JE5A6QP")
        // (device "Bill"
          "7WS6MZD-R5UXQLX-A5S4OPX-2STUU3R-YZG5XYL-PQ2WE6C-XSIQU3J-TZLNGQI")
        // (device "mbpyc"
          "6QN2KGI-7BQRMML-PR4CDUX-N252KGI-LWTF3SA-HDN6NFD-DF6WAP4-WNFJLQ3")
        ;

        settings.folders = {
          dox = {
            enable = mkDefault false;
            id = "rfkc3-ae2wq";
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
