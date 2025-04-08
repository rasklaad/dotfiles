#!/bin/sh

#xrandr --output DP-4 --auto --primary
#xrandr --output eDP-1 --off
#feh --bg-scale ~/Pictures/Minimal-Nord.png

swaymsg output eDP-1 scale 1.5 enable
swaymsg output DP-4 scale 1.5 enable
