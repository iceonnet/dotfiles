#!/bin/bash

X=$(ps -A | grep i3lock)

if [ $? -eq 0 ]
then
        killall i3lock
fi


STEPS=25
INTERVAL=1		# In ms

ERROR=0
$(xrandr -v >/dev/null 2>&1)
if [[ $? > 1 ]]; then
	echo "Missing: xrandr" && let ERROR=ERROR+1
fi

$(bc -v >/dev/null 2>&1)
if [[ $? > 1 ]]; then
	echo "Missing: bc" && let ERROR=ERROR+1
fi

if [[ $ERROR -gt 0 ]]; then
	exit 0
fi

lock&

xset dpms 15

DISPLAYS=$(xrandr | grep " connected" | awk '{print $1}')
I=0
pkill redshift
while [ $I -le $STEPS ]; do
	for line in $DISPLAYS; do
		# xrandr --output $line --brightness $(bc <<< 'scale=2; '$STEPS'/'$STEPS'-'$I'/'$STEPS'/'1.25)
		xrandr --output $line --brightness $(bc <<< 'scale=2; 1-'$I'/'$STEPS'/'1.25)
	done

	let I=I+1
	sleep $(bc <<< 'scale=2; 0.001*'$INTERVAL)
done


echo waiting
while [[ $(ps -A | grep i3lock | wc -l) < 1 ]]; do # Keeps the script busy while waiting for i3lock to start
	sleep 1
done

redshift &
while :; do
	if [[ $(ps -A | grep i3lock | wc -l) < 1 ]]; then
		for line in $DISPLAYS; do
			xrandr --output $line --brightness 1
		done
		xset dpms 0
		break
	fi
	sleep 0.25
done

exit 0
