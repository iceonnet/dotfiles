#!/bin/bash

DISPLAY=$(cat /proc/$$/environ | tr '\0' '\n' | grep '^DISPLAY=' | sed "s/DISPLAY=//")
PASINK=$(pactl list sinks | grep RUNNING -B 1 | gawk 'match($0, /Sink #([0-9]+)/, ary) { print ary[1] }')

# if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
# fi

