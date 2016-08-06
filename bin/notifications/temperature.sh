#!/bin/sh

CPU=$(sensors | grep "Physical id 0" | awk '{ print $4 }')
CPU=$(echo `expr substr $CPU 2 2`)c

export DISPLAY=:0.0
GPU=$(nvidia-settings -q gpucoretemp | awk '/Attribute.*: (\w+)\./{ print $4 }')
GPU=$(echo `expr substr $GPU 1 2`)c

notify-send "CPU: $CPU | GPU: $GPU"

exit 0