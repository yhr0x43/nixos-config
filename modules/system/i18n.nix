{ config, lib, pkgs, ... }:

with lib;

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
      #TODO: switch to fcitx5
      inputMethod = {
        enabled = "fcitx5";
        fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
        fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-rime ];
      };
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    time.timeZone = "America/Chicago";
  };
}
