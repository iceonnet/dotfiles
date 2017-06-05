#!/bin/sh

# Get PID of self
export DISPLAY=$('helper.displayfromselfpid.sh').0

# CPU=$(sensors | grep "Physical id 0" | awk '{ print $4 }')
CPU=$(sensors | grep "Package id 0" | awk '{ print $4 }')
CPU=$(echo `expr substr $CPU 2 2`)

GPU=$(nvidia-settings -q gpucoretemp | awk '/Attribute.*: (\w+)\./{ print $4 }')
GPU=$(echo `expr substr $GPU 1 2`)

[ -z $CPU ] || notify-send -t 1 "CPU: $CPU"c
[ -z $GPU ] || notify-send -t 1 "GPU: $GPU"c

exit 0
