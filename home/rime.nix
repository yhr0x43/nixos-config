{ config, pkgs, ... }:

{
  xdg.dataFile."fcitx5/rime" = {
    recursive = true;
    source = ./rime;
  };
}
