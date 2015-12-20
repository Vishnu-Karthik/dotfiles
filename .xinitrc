#!/bin/bash

# ~/.xinitrc

# set background
sh ~/.fehbg &

# set compositing
compton -bCGc -r 2 -o 0.60 -l 0 -t 0 &

# start mpd
mpd &

# mute beep
xset -b

# set xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# start panel
dzen.sh | dzen2 -w '1366' -h '20' -x '0' -y '0' -ta l &

# begin window manager
sxhkd &
exec bspwm

