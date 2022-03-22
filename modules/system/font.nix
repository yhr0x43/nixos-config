{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.fonts;

in {
  options.system.custom.fonts = {
    enable = mkEnableOption "enable fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;
      enableDefaultFonts = true;
      enableGhostscriptFonts = true;

      fontconfig = {
        enable = true;
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
        hinting = {
          enable = true;
          autohint = false;
        };
        antialias = true;
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          serif = [ "DejaVu Serif" ];
          monospace = [ "DejaVu Sans Mono" ];
        };
      };

      fonts = with pkgs; [
        corefonts
        hasklig
        inconsolata
        source-code-pro
        ubuntu_font_family

        # symbol fonts
        # ------------
        powerline-fonts
        font-awesome-ttf
        fira-code

        # shell font
        # ----------
        terminus_font
        gohufont

        # CJK
        # ----------
        #noto-fonts
        noto-fonts-cjk
        #noto-fonts-emoji

        # Math
        # ---------
        libertinus
      ];
    };
  };
}
