{ pkgs, ... }: {
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

}
