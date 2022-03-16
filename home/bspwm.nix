{ pkgs, config, ... }:
{
  imports = [ ./autorandr.nix ];

  services.sxhkd = {
    enable = true;
    package = pkgs.writeShellScriptBin "sxhkd"
      ''
        ${pkgs.coreutils}/bin/env _JAVA_AWT_WM_NONREPARENTING=1 ${pkgs.sxhkd}/bin/sxhkd $@
      '';
    extraOptions = [ "-r /tmp/sxhkd_out" ];
    keybindings = {
      "super + Escape" = "pkill -USR1 -x sxhkd";
      "super + Return" = "alacritty";
      "ctrl + alt + Return" = "dmenu_run";
      "super + alt + Return" = "j4-dmenu-desktop";
      "super + ctrl + space" = "bspc node -p cancel";
      "super + d" = "notify-send $PATH";
      "super + shift + c" = "bspc node -c";
      "super + shift + q" = "bspc quit";
      "super + y" = "bspc node -n newest.!automatic.local";
      "super + {_,shift + ,ctrl + }{h,j,k,l}" = "bspc node -{f,s,p} {west,south,north,east}";
      "super + {_,shift + }{1-9}" = "bspc {desktop -f,node -d} focused:'^{1-9}'";
      "super + {t,s,f}" = "bspc node -t {tiled,floating,fullscreen}";
      "XF86AudioPlay" = "${pkgs.playerctl}/bin/playerctl play-pause";
      "XF86AudioNext" = "${pkgs.playerctl}/bin/playerctl next";
      "XF86AudioPrev" = "${pkgs.playerctl}/bin/playerctl previous";
      "Print" = "flameshot gui";
    };
  };

  xsession.windowManager.bspwm = {
    enable = true;
    settings = {
        active_border_color = "#1E1E1E";
        border_width = 4;
        borderless_monocle = true;
        bottom_padding = 0;
        click_to_focus = "button1";
        focused_border_color = "#5E81BC";
        gapless_monocle = true;
        left_padding = 0;
        merge_overlapping_monitors = true;
        normal_border_color = "#4c566a";
        pointer_action1 = "move";
        pointer_action2 = "resize_side";
        pointer_action3 = "resize_corner";
        pointer_modifier = "mod4";
        presel_feedback_color = "#5e81ac";
        remove_disabled_monitors = true;
        right_padding = 0;
        single_monocle = true;
        split_ratio = 0.500000;
        top_padding = 30;
        window_gap = 5;
    };
    rules = {
      "pinentry".state = "floating";
    };
    startupPrograms = [
      "autorandr -c"
    ];
  };
}
