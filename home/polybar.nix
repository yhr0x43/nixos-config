{ pkgs, lib, ... }:

let
  colors = {
    black = "\${xrdb:color0:#1d2021}";
    darkred = "\${xrdb:color1:#cc241d}";
    darkgreen = "\${xrdb:color2:#98971a}";
    darkyellow = "\${xrdb:color3:#d79921}";
    darkblue = "\${xrdb:color4:#458588}";
    darkmagenta = "\${xrdb:color5:#b16286}";
    darkcyan = "\${xrdb:color6:#689d6a}";
    lightgray = "\${xrdb:color7:#a89984}";
    gray = "\${xrdb:color8:#928374}";
    red = "\${xrdb:color9:#fb4934}";
    green = "\${xrdb:color10:#b8bb26}";
    yellow = "\${xrdb:color11:#fabd2f}";
    blue = "\${xrdb:color12:#83a598}";
    magenta = "\${xrdb:color13:#d3869b}";
    cyan = "\${xrdb:color14:#8ec07c}";
    white = "\${xrdb:color15:#ebdbb2}";
    background = "\${xrdb:color256:#1d2021}";
    foreground = "\${xrdb:color257:#ebdbb2}";
  };
  bar-common = {
    monitor-fallback = "\${env:MONITOR:HDMI-A-0}";
    monitor-strict = false;
    monitor-exact = true;
    override-redirect = false;

    enable-ipc = true;
    width = "100%";
    height =  "3%";
    #offset-x = 1%;
    #offset-y = 1%;
    #radius = 6.0;
    fixed-center = true;
    locale = "ja_JP.UTF-8";

    background = "\${colors.background}";
    foreground = "\${colors.foreground}";

    line.size = 3;
    line.color = "\${colors.red}";

    padding.left = 0;
    padding.right = 0;

    module-margin = 2;

    font = [
      "mono:pixelsize=12#1"
      "Noto Color Emoji:scale=10:style=Regular#2"
      "Symbola:pixelsize=9#1"
      "Font Awesome 5 Free:style=Solid"
      "UbuntuMono Nerd Font Mono:sytle=Regular"
      "Noto Sans CJK SC:style=Regular"
    ];

    tray-position = "right";
    tray-padding = 0;

    wm-restack = "bspwm";

    scroll-up = "#bspwm.prev";
    scroll-down = "#bspwm.next";

    cursor-click = "pointer";
  };
in
{
  services.polybar = {
    enable = true;
    script = "polybar default &";
    settings = {
      inherit colors;
      "bar/default" = {
        modules-left = lib.mkDefault "bspwm xwindow";
        modules-center = lib.mkDefault "date yubikey";
        modules-right = lib.mkDefault "battery filesystem";
      } // bar-common ;
      "module/bspwm" = {
        type = "internal/bspwm";

        ws.icon =  [ "1;壹" "2;贰" "3;叁" "4;肆" "5;伍" "6;陆" "7;柒" "8;捌" "9;玖" ];

        label-focused = "%icon%";
        label-focused-foreground = "\${colors.black}";
        label-focused-background = "\${colors.blue}";
        label-focused-underline= "\${colors.yellow}";
        label-focused-padding = 1;

        label-occupied = "%icon%";
        label-occupied-underline = "\${colors.blue}";
        label-occupied-padding = 1;

        label-urgent = "%icon%!";
        label-urgent-background = "\${colors.red}";
        label-urgent-padding = 1;

        label-empty = "%icon%";
        #label-empty-foreground = "\${colors.lightgray}";
        label-empty-padding = 1;
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:45:...%";
        format-foreground = "\${colors.blue}";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format-prefix = "🌡";
        format-prefix-foreground = "\${colors.gray}";
        format-underline = "\${colors.red}";
        label = "%percentage%%";
      };
      "module/memory" = {
        type = "internal/memory";
        interval = 2;
        format-prefix = " ";
        format-prefix-foreground = "\${colors.gray}";
        format-underline = "\${colors.darkcyan}";
        label = "%percentage_used%%";
      };
      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;

        mount = [ "/nix" "/home" ];

        label-mounted = "%mountpoint%: %used%";
        label-mounted-underline = "\${colors.cyan}";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.gray}";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;

        date = "%b%d (%a)";
        time = "%T";

        format.prefix.foreground = "\${colors.gray}";
        format.underline = "\${colors.blue}";

        label = "%date% %time%";
      };
      "module/yubikey" = {
        type = "custom/script";

        exec = ''${pkgs.nmap}/bin/ncat --unixsock $XDG_RUNTIME_DIR/yubikey-touch-detector.socket | while read -n5 message; do [[ $message = *1 ]] && echo "  " || echo ""; done'';
        tail = true;

        format-foreground = "#ffffff";
        format-background = "#ff0000";
      };
      "settings" = {
        screenchange-reload = true;
        #compositing-background = xor
        #compositing-background = screen
        compositing-foreground = "source";
        #compositing-border = over
      };
      "global/wm" = {
        margin-top = 5;
        margin-bottom = 5;
      };
    };
  };
}
