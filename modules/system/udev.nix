{ pkgs, config, lib, ... }:

with lib;

let

  cfg = config.system.custom.udev;

in {
  options.system.custom.udev = {
    hackRF = mkEnableOption "udev rule to use uaccess for hackrf";
    ATmega32U4 = mkEnableOption "udev rule to use uaccess for writing ATmega32U4 DFU";
    dsLogic = mkEnableOption "udev rule to use uaccess for dsLogic";
    feitianFIDO = mkEnableOption "udev rule for feitian FIDO U2F devices";
  };

  config.services.udev.extraRules = concatStrings [
    (optionalString cfg.hackRF ''
      # HackRF Jawbreaker
      ATTR{idVendor}=="1d50", ATTR{idProduct}=="604b", SYMLINK+="hackrf-jawbreaker-%k", MODE="660", TAG+="uaccess"
      # HackRF One
      ATTR{idVendor}=="1d50", ATTR{idProduct}=="6089", SYMLINK+="hackrf-one-%k", MODE="660", TAG+="uaccess"
      # rad1o
      ATTR{idVendor}=="1d50", ATTR{idProduct}=="cc15", SYMLINK+="rad1o-%k", MODE="660", TAG+="uaccess"
      # NXP Semiconductors DFU mode (HackRF and rad1o)
      ATTR{idVendor}=="1fc9", ATTR{idProduct}=="000c", SYMLINK+="nxp-dfu-%k", MODE="660", TAG+="uaccess"
      # rad1o "full flash" mode
      KERNEL=="sd?", SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="1fc9", ENV{ID_MODEL_ID}=="0042", SYMLINK+="rad1o-flash-%k", MODE="660", TAG+="uaccess"
      # rad1o flash disk
      KERNEL=="sd?", SUBSYSTEM=="block", ENV{ID_VENDOR_ID}=="1fc9", ENV{ID_MODEL_ID}=="0082", SYMLINK+="rad1o-msc-%k", MODE="660", TAG+="uaccess"
    '')

    (optionalString cfg.ATmega32U4 ''
      # ATmega32U4
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", TAG+="uaccess"
    '')

    (optionalString cfg.feitianFIDO ''
      ACTION!="add|change", GOTO="u2f_end"
      # Feitian ePass FIDO, BioPass FIDO2, KeyID U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b|085d|085f|0862|0864|0865|0866|0867", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      LABEL="u2f_end"
    '')
  ];

  config.services.udev.packages =
    mkIf cfg.dsLogic [ pkgs.dsview ];
}
