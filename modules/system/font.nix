{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.system.custom.fonts;

in {

  options.system.custom.fonts = {
    enable = mkEnableOption "enable fonts";
    dpi = mkOption {
      type = types.int;
      default = 141;
      description = ''
        dpi of the monitor
      '';
    };
  };

  config = mkIf cfg.enable {

    fonts = {

      enableFontDir = true;
      enableGhostscriptFonts = true;

      fontconfig = {
        dpi = cfg.dpi;
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
        hinting = {
          enable = true;
          autohint = false;
        };
        enable = true;
        antialias = true;
        defaultFonts = { monospace = [ "inconsolata" ]; };
      };

      fonts = with pkgs; [

        #corefonts
        hasklig
        inconsolata
        source-code-pro
        symbola
        ubuntu_font_family

        # symbol fonts
        # ------------
        #nerdfonts
        powerline-fonts
        font-awesome-ttf
        fira-code-symbols

        # shell font
        # ----------
        terminus_font
        gohufont

        # CJK?
        # noto-fonts
        noto-fonts-cjk
        # noto-fonts-emoji

      ];

    };

  };

}

