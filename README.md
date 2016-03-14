# dotfiles

dependencies:
 - feh
 - rofi
 - scrot
 - xautolock


```
Usage: ./yank_into_position.sh [sym, copy]
    sym     creates a symlink between the originating files and the configuration files
    cp      copies the configuration files directly

    The script will always check for existing files/folders and create a backup of as following:
      ~/.i3_backup(CURRENT_DATE)
      ~/.Xresources
```
