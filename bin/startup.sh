#!/bin/bash

xset s off off -dpms

# Locker
    (xautolock -corners ---- -time 15 -locker ~/bin/lock_fadeout.sh &) && notify-send -u critical "[xautolock] started"

# redshift
    killall redshift; redshift & notify-send "[redshift] started"

# Dropbox
    dropbox start && notify-send "[Drobox] started"

# Nvidia Fan Controller
    kill $(cat bin/nvidiafanspeed/nvidiafanspeed.lock)
    (~/bin/nvidiafanspeed/nvidiafanspeed.sh &) && notify-send -u critical "[nvidiafanspeed] started"

# Compton
    # compton -D 5 -f --glx-copy-from-front && notify-send "[compton] started"

# Setup Default audio sink
    pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo &

# Setup monitors
    sleep 5
    (xrandr --output DP-0 --auto --primary; xrandr --output DVI-D-0 --mode 1920x1080 --right-of DP-0
        ) && notify-send "[xrandr] monitors"

# set background
    feh --bg-fill  ~/Pictures/Wallpapers/3440x1440/wallhaven-293156.png && notify-send "[feh] wallpaper set"


# TeamViewer monitor / killer
# killall tv_start.sh
# killall TeamViewer.exe
# ~/bin/tv_start.sh   && notify-send "[tv_start] started"
# ~/bin/tv_monitor.sh && notify-send "[tv_monitor] started"
