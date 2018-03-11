#!/bin/bash

export DISPLAY=:1

xset r rate 250 25
xset -dpms
wal -R

stop() {
    pkill xautolock
    pkill redshift
    pkill gsd-xsettings
    dropbox stop

    kill $(cat /tmp/nvidiafanspeed.pid)
}

if [ ${1:-""} == "restart" ]; then
    killall compton -USR1
    stop
fi

if [ ${1:-""} == "stop" ]; then
    stop
    pkill compton
    exit
fi

# Dunst {{{
    if [ $(pgrep dunst) ]; then
        pkill dunst && sleep 1
    fi # }}}
# Locker {{{
    if [ ! $(pgrep xautolock) ]; then
        (xautolock -corners ---- -time 30 -locker ~/bin/lock -nowlocker ~/bin/lock)&
        notify-send -u low "[] xautolock started"
    fi # }}}
# redshift {{{
    if [ ! $(pgrep redshift) ]; then
        redshift &
        notify-send -u low "[] redshift started"
    fi # }}}
# Dropbox {{{
    if [ ! $(pgrep dropbox) ]; then
        dropbox start -i
        notify-send -u low "[] drobox started"
    fi # }}}
# Nvidia Fan Controller {{{
    if [ ! $(pgrep nvidiafanspeed) ]; then
        ~/bin/nvidiafanspeed/nvidiafanspeed.sh &
        notify-send -u low "[] nvidiafanspeed started"
    fi # }}}
# Compton {{{
    if [ ! $(pgrep compton) ]; then
        compton &
        notify-send -u low "[] compton started"
    fi # }}}
# Setup monitors {{{
    (xrandr --output DP-4 --mode 2560x1440 --rate 165 --primary;
    xrandr --output DP-0 --mode 2560x1440 --rate 165 --right-of DP-4
    ) && notify-send -u low "[] xrandr monitors"
# }}}
# Gnome Settings Daemon {{{
    pkill -U $USER gsd-xsettings;
    /usr/lib/gnome-settings-daemon/gsd-xsettings &  # Ubuntu 17.10
    # gnome-settings-daemon &  # Ubuntu Gnome 16.04
    notify-send -u low "[] gsd started"
# }}}

# # Setup Default audio sink
#     pactl set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo &

# # TeamViewer monitor / killer
# # killall tv_start.sh
# # killall TeamViewer.exe
# # ~/bin/tv_start.sh   && notify-send -u low "[tv_start] started"
# # ~/bin/tv_monitor.sh && notify-send -u low "[tv_monitor] started"

exit 0
