{ pkgs, ... }: {
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-rime ];
    fcitx.engines = with pkgs.fcitx-engines; [ mozc rime ];
  };
}
