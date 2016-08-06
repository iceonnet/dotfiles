#!/bin/bash

function ttt  {
    echo "" > "/tmp/nvidiatemp.txt"
}
trap ttt SIGINT SIGKILL SIGTERM

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
python $DIR/nvidiafanspeed.py

nvidia-settings -a "[gpu:0]/GPUFanControlState=0"

sleep 1

cat /tmp/nvidiatemp.txt