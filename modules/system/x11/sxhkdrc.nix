{ pkgs }:

pkgs.writeText "sxhkdrc"
''
super + Return
	${pkgs.alacritty}/bin/alacritty

ctrl + alt + Return
	${pkgs.dmenu}/bin/dmenu_run

super + alt + Return
	${pkgs.j4-dmenu-desktop}/bin/j4-dmenu-desktop

super + ctrl + space
	bspc node -p cancel

super + d
	notify-send $PATH

super + shift + c
	bspc node -c

super + shift + q
	bspc quit

super + y
	bspc node -n newest.!automatic.local

super + {_,shift + ,ctrl + }{h,j,k,l}
	bspc node -{f,s,p} {west,south,north,east}

super + {_,shift + }{1-9}
	bspc {desktop -f,node -d} focused:'^{1-9}'

super + {t,s,f}
	bspc node -t {tiled,floating,fullscreen}

XF86Audio{Next,Prev}
	${pkgs.playerctl}/bin/playerctl {next,previous}

XF86AudioPlay
	${pkgs.playerctl}/bin/playerctl play-pause

XF86Audio{LowerVolume,RaiseVolume}
	${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ {-2%,+2%}

XF86AudioMute
	${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle

XF86MonBrightness{Down,Up}
	${pkgs.light}/bin/light {-U,-A} 5

Print
	${pkgs.flameshot}/bin/flameshot gui
''
