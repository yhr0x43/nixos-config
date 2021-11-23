{ config, ... }:

{
  i18n = {
    defaultLocale = "ja_JP.utf-8";
    supportedLocales = [ "ja_JP.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  time.timeZone = "America/Chicago";
}
