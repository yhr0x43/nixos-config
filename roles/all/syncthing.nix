{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault;

in {

  services.syncthing = {
    declarative = {
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
        "2T4GJCW-HWQZ52B-DD6LF62-ALJERG5-P3S4CIJ-O4ULWNO-IQB4LFO-N5H5OQM")
      // (device "cybermega"
        "P6ZS6XU-AUHWG7S-BJTFDEO-ABPDFLA-YBWB2T2-XV52M7D-NVZAYAE-IWFT3QJ")
      ;

      folders = {
        dox = {
          enable = mkDefault false;
          id = "rfkc3-ae2wq";
          #watch = false;
          devices = [ "k26" "tpx1c" "cybermega" ];
          versioning = {
            type = "simple";
            params.keep = "5";
          };
        };
        pass = {
          enable = mkDefault false;
          id = "nmdgd-nr5ik";
          #watch = false;
          devices = [ "k26" "tpx1c" "cybermega" ];
        };
      };
    };
  };

}
