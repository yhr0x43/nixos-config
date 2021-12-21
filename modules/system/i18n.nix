{ config, lib, pkgs, ... }:

let

  cfg = config.system.custom.i18n;

in {
  options.system.custom.i18n = {
    enable = mkEnableOption "custom i18n configs";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "ja_JP.utf-8";
      supportedLocales = [ "ja_JP.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
      inputMethod = {
        enabled = "fcitx";
        fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
        fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
      };
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "America/Chicago";
  };
}
