#! /bin/sh

#xrandr --output eDP-1 --auto
#xrandr --output DP-2 --off
swaymsg output eDP-1 enable
swaymsg output DP-4 disable
