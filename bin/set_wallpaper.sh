#!/bin/zsh

WALLPAPER_DIR="$HOME/Dropbox/Pictures/Wallpapers/2560x1440/"

pgrep "^wal$" && notify-send -u critical -t 2000 "wal already running" && exit

#if [ "${1}" != "" ]; then
#        IMAGE=${1}
#else
#        IMAGE=${WALLPAPER_DIR}
#fi

IMAGE=${1:-${WALLPAPER_DIR}}

[[ -f ${IMAGE} || -d ${IMAGE} ]] || (notify-send -u critical -t 5000 wal "File not found: ${IMAGE}" && exit)

wal -i ${IMAGE} | tee /tmp/wal.log
SUCCESS=$?
IMAGE=$(grep "Using image" /tmp/wal.log | sed 's/image: Using image //g')

echo SUCCESS: ${SUCCESS}



if [ ${SUCCESS} -eq 0 ]; then
        notify-send -u low -t 1000 "wal" "$(basename ${IMAGE})"
else
        notify-send -u critical -t 10000 "wal" "Failed generating color palette:\n${IMAGE}"
fi

