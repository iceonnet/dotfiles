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

PACKAGES=(alacarte compton curl feh git gparted htop i3 i3blocks nvidia-367 nvidia-settings oracle-java8-installer playonlinux python-dev python-pip redshift rofi screenfetch sensord sublime-text-installer terminator vim xautolock zsh)


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
    echo "[Apt] Adding PPAs" >> $USER_HOME_PATH/restore.log
    sleep 2
    add-apt-repository --yes ppa:webupd8team/sublime-text-3
    add-apt-repository --yes ppa:graphics-drivers/ppa  # Added due to Nvidia 1080
    apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'  # Wine staging
    # add-apt-repository --yes ppa:webupd8team/java -s

# Repo Keys
wget -nc https://repos.wine-staging.com/wine/Release.key -O /tmp/Release_Wine.key && apt-key add /tmp/Release_Wine.key

# Update APT
    echo "[Apt] upgdate & upgrade" >> $USER_HOME_PATH/restore.log
    sleep 2
    apt-get update
    apt-get upgrade -y
    apt-get install -f -y

# Install packages
    echo "[Apt] installing Packages" >> $USER_HOME_PATH/restore.log
    sleep 2

    for PACKAGE in ${PACKAGES[@]}; do
        echo "" >> $USER_HOME_PATH/restore.log
        echo "[apt-get] $PACKAGE" >> $USER_HOME_PATH/restore.log
        (apt-get install -y $PACKAGE 2>> $USER_HOME_PATH/restore.log && echo "OK" >> $USER_HOME_PATH/restore.log) || echo "Fail" >> $USER_HOME_PATH/restore.log
    done

    # Wine Staging
    apt-get install --install-recommends winehq-staging
    
    apt-get install -f -y

# pip
    echo "[PIP] Upgrade and install autoremove" >> $USER_HOME_PATH/restore.log
    pip install --upgrade pip
    pip install pip-autoremove


# Install "loose" packages
    echo "[dpkg] Installing loose packages" >> $USER_HOME_PATH/restore.log
    sleep 2
    cd /tmp/

    # Steam
    wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && dpkg -i steam.deb && echo "Steam OK" >> $USER_HOME_PATH/restore.log

    # Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && echo "Chrome OK" >> $USER_HOME_PATH/restore.log
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
    echo "Installing oh-my-zsh" >> $USER_HOME_PATH/restore.log
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Sublime Package Manager
    mkdir -p $USER_HOME_PATH/.config/sublime-text-3/Installed\ Packages
    wget -O $USER_HOME_PATH/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package https://packagecontrol.io/Package%20Control.sublime-package


# Copy configs
    echo "Fetching dotfiles" >> $USER_HOME_PATH/restore.log
    git clone https://github.com/husjon/dotfiles.git
	cp dunst $USER_HOME_PATH/.config/
	cp i3 $USER_HOME_PATH/.i3
	cp terminator $USER_HOME_PATH/.config/
	cp Xresources $USER_HOME_PATH/.Xresources
	cp zshrc $USER_HOME_PATH/.zshrc



# Fonts
    echo "[font] installing fonts" >> $USER_HOME_PATH/restore.log
    sleep 2
    mkdir $USER_HOME_PATH/.fonts
    wget https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf -O /usr/local/share/fonts/fontawesome-webfont.ttf
    fc-cache -f -v


# Theming
    wget wget http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/all/arc-theme_1488477732.766ae1a-0_all.deb -O /tmp/arc-theme.deb
    dpkg -i /tmp/arc-theme.deb


# Tweaks
    echo "[Tweaks] Making minor tweaks." >> $USER_HOME_PATH/restore.log
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
