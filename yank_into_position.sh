#!/bin/bash

PWD=$(pwd)
DATE=$(date +%H%M%S-%Y%m%d)

if [ -e "$HOME/.i3" ]; then # creates a backup before copying over
    echo "backing up i3"
    mv -f "$HOME/.i3" "$HOME/.i3_backup($DATE)"
fi

if [ -e "$HOME/.Xresources" ]; then
    echo "backing up Xresources"
    mv -f "$HOME/.Xresources" "$HOME/.Xresources_backup($DATE)"
fi

case "$1" in
    sym)
        echo "Symlinking configuration"
        ln -s "$PWD/.i3" "$HOME/.i3"
        ln -s "$PWD/.Xresources" "$HOME/.Xresources"
        ;;
    cp)
        echo "Copying configuration"
        cp -r "$PWD/.i3/" "$HOME/.i3/"
        cp "$PWD/.Xresources" "$HOME/.Xresources"
        ;;
    *)
        echo "Usage: $0 [sym, copy]
    sym     creates a symlink between the originating files and the configuration files
    cp      copies the configuration files directly

    The script will always check for existing files/folders and create a backup of as following:
      ~/.i3_backup(CURRENT_DATE)
      ~/.Xresources" >&2
        exit 1
        ;;
esac


echo "Restarting i3"
i3-msg restart
echo "Done"
