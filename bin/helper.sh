#!/bin/bash

DISPLAY=$(cat /proc/$$/environ | tr '\0' '\n' | grep '^DISPLAY=' | sed "s/DISPLAY=//")

# if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
# fi

