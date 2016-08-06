#!/bin/bash

# Delaying xautolocks locker if Rocket League is running (with wine)
# Xbox controller does not reset the idle timer.

STATE=0
if pgrep "Rocket" > /dev/null; then
	STATE=1
fi

if [ $STATE -eq 1 ];
then
	xautolock -disable && echo ""  # Returning a unlocked padlock

else
	xautolock -enable && echo ""  # Returning a locked padlock
fi

exit 0