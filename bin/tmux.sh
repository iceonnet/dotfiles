#!/bin/bash

(cat ~/.cache/wal/sequences&)

[[ $(tmux has-session 2>&1) =~ "no server" ]] && tmux || tmux attach
