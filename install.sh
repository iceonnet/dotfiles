#!/bin/bash

clear
function waitForInput {
    read -p "Press any key to continue" -n1
}

USER=$(whoami)
if [ $USER != "root" ]; then
    echo "Please start this script with sudo."
    exit
fi


USER_HOME_PATH=/home/$SUDO_USER
SOFTWARE_PATH=$USER_HOME_PATH/Software
DIST_CODENAME=$(awk -F'CODENAME=' '{ print $2 }' /etc/lsb-release | tr -d '[[:space:]]')

PACKAGES=(alacarte curl feh git gparted htop i3 i3blocks nvidia-367 nvidia-settings oracle-java8-installer playonlinux python-dev python-pip redshift screenfetch sensord sublime-text-installer terminator vim xautolock zsh)


echo "Log of restoration" > $USER_HOME_PATH/restore.log


echo "
This will install the following packages:
  ${PACKAGES[@]}

This will also do the following:
- Changes Alt move to Super(Win) move
- Disable Media autorun
"
waitForInput
clear


# PPA lists
    echo "[Apt] Adding PPAs"
    sleep 2
    add-apt-repository --yes ppa:webupd8team/sublime-text-3
    add-apt-repository --yes ppa:graphics-drivers/ppa  # Added due to Nvidia 1080
    add-apt-repository --yes ppa:webupd8team/java -s

# Update APT
    echo "[Apt] upgdate & upgrade"
    sleep 2
    apt-get update
    apt-get upgrade -y
    apt-get install -f -y

# Install packages
    echo "[Apt] installing Packages"
    sleep 2

    for PACKAGE in ${PACKAGES[@]}; do
        echo "" >> $USER_HOME_PATH/restore.log
        echo "[apt-get] $PACKAGE" >> $USER_HOME_PATH/restore.log
        apt-get install -y $PACKAGE 2>> $USER_HOME_PATH/restore.log && echo "OK" >> $USER_HOME_PATH/restore.log
    done

    apt-get install -f -y

# pip
    pip install --upgrade pip
    pip install pip-autoremove



# Configuration Changes
    echo "[Grub] Changing to console boot"
    sleep 2
    # Setup grub for console boot
        cp /etc/default/grub /etc/default/grub.orig

        sed 's/^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g
            s/^GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="text"/g
            s/^#GRUB_TERMINAL=console/GRUB_TERMINAL=console/g' /etc/default/grub.orig > /etc/default/grub
        update-grub
        systemctl set-default multi-user.target


# Install "loose" packages
    echo "[dpkg] Installing loose packages"
    sleep 2
    cd /tmp/

    # Steam
    wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && dpkg -i steam.deb

    # Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome-stable_current_amd64.deb

    # Software
        mkdir $SOFTWARE_PATH && cd $_

        # PyCharm
            wget https://download.jetbrains.com/python/pycharm-professional-2016.2.tar.gz -O - | tar xz
        # Arduino
            curl http://downloads.arduino.cc/arduino-1.6.10-linux64.tar.xz | tar -xJ

        chown -R $SUDO_USER:$SUDO_USER $SOFTWARE_PATH


# Fetch from GitHub
    # Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Copy configs
    git clone https://github.com/iceonnet/dotfiles.git
	cp dunst $USER_HOME_PATH/.config/
	cp i3 $USER_HOME_PATH/.i3
	cp terminator $USER_HOME_PATH/.config/
	cp Xresources $USER_HOME_PATH/.Xresources
	cp zshrc $USER_HOME_PATH/.zshrc



# Fonts
    echo "[font] installing fonts"
    sleep 2
    mkdir $USER_HOME_PATH/.fonts
    wget https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf -o $_/fontawesome-webfont.ttf
    fc-cache -fv


# Tweaks
    echo "[Tweaks] Making minor tweaks."
    sleep 2
    su $SUDO_USER bash -c 'gsettings set org.gnome.desktop.media-handling autorun-never true'                   # Disables autorun of USB-disks and CD/DVD when mounted.
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences executable-text-activation ask'         # ask to run / display executable text files (f.ex .python, .sh)
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences enable-interactive-search false'        # Enable interactive search
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences sort-directories-first true'            # Set Nautilus to sort folders first

    # Gnome Terminal Tweaks
    echo "[dconf] Gnome Terminal - Setting up profile."
    sleep 2
    PROFILE=$(dconf list /org/gnome/terminal/legacy/profiles:/)
    su $SUDO_USER bash -c "dconf write /org/gnome/terminal/legacy/profiles:/"$PROFILE"/background-color \"'rgb(43,48,59)'\""
    su $SUDO_USER bash -c "dconf write /org/gnome/terminal/legacy/profiles:/"$PROFILE"/foreground-color \"'rgb(192,197,206)'\""



# Final message
    echo "Computer needs to be rebooted for the NVidia drivers to take effect"
    echo "Press CTRL+C to reboot later or "
    waitForInput
    reboot
