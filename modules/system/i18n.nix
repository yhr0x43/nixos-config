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
      inputMethod = {
        # type = "fcitx5";
        # enable = true;
        enabled = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          # fcitx5-gtk
          kdePackages.fcitx5-qt
          fcitx5-mozc
          fcitx5-rime
        ];
      };
    };
    
    environment.systemPackages = [ pkgs.rime-data ];

    environment.sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };
  };
}
