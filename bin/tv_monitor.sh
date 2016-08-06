#!/bin/bash

# Locks the workstation when a TeamViewer session has ended.

LAST_STATE=0
while true; do
	clear
	COUNT=0

	for line in `lsof -i4 -Pn | grep TeamViewe | awk '{ print $1 }'`; do
		COUNT=$(($COUNT+1))
	done

	if [[ $COUNT > 1 ]]; then
		STATE=1
	else
		STATE=0
	fi

	if [[ $STATE != $LAST_STATE ]]; then
		if [[ $STATE == 1 ]]; then
			echo "Incoming connection"
		else
			echo "Connection finished"
			touch ~/Dropbox/.tvstop
			i3-msg workspace "6"
			i3-msg workspace "1 "
			xrandr --output DVI-D-0 --panning 1920x1080+3440+0
			xautolock -locknow
		fi
	fi

	LAST_STATE=$STATE
	sleep 1
done &

echo "[TeamViewer Monitor] started"
