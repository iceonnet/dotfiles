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

source /etc/lsb-release  # Distribution information

HOME=/home/$SUDO_USER
SOFTWARE_PATH=$HOME/Software

PACKAGES=(alacarte compton curl dropbox feh git gparted htop i3 i3blocks
    nvidia-367 nvidia-settings oracle-java8-installer playonlinux python-dev
    python-pip redshift rofi screenfetch sensord spotify-client
    sublime-text-installer terminator vim xautolock zsh libxcb-ewmh-dev
    autoconf libev-dev libpango1.0-dev libstartup-notification0-dev
    libxcb-cursor-dev libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-randr0-dev
    libxcb-util0-dev libxcb-xinerama0-dev libxcb-xkb-dev libxcb-xrm-dev
    libxcb1-dev libxkbcommon-dev libxkbcommon-x11-dev libyajl-dev
    libc++1)


echo "Log of restoration" > $HOME/restore.log

echo $HOME

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
    echo "[Apt] Adding PPAs" >> $HOME/restore.log
    sleep 2
    add-apt-repository --yes ppa:webupd8team/sublime-text-3
    add-apt-repository --yes ppa:graphics-drivers/ppa  # Added due to Nvidia 1080
    add-apt-repository ppa:aguignard/ppa  # Added due to i3-gaps
    apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'  # Wine staging
    # add-apt-repository --yes ppa:webupd8team/java -s
    echo deb http://repository.spotify.com stable non-free | \
        sudo tee /etc/apt/sources.list.d/spotify.list
    echo deb http://linux.dropbox.com/ubuntu $DISTRIB_CODENAME main | \
        sudo tee /etc/apt/sources.list.d/dropbox.list

# Repo Keys
    wget -nc https://repos.wine-staging.com/wine/Release.key \
        -O /tmp/Release_Wine.key && apt-key add /tmp/Release_Wine.key  # Wine
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886  # Spotify
    apt-key adv --keyserver pgp.mit.edu \
        --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E  # Dropbox

# Update APT
    echo "[Apt] update & upgrade" >> $HOME/restore.log
    sleep 2
    apt-get update
    apt-get upgrade -y
    apt-get install -f -y

# Install packages
    echo "[Apt] installing Packages" >> $HOME/restore.log
    sleep 2

    for PACKAGE in ${PACKAGES[@]}; do
        echo "" >> $HOME/restore.log
        echo "[apt-get] $PACKAGE" >> $HOME/restore.log
        apt-get install -y $PACKAGE 2>> $HOME/restore.log && \
            echo "OK" >> $HOME/restore.log || echo "Fail" >> $HOME/restore.log
    done

    # Wine Staging
    apt-get install --install-recommends winehq-staging

    apt-get install -f -y

# pip
    echo "[PIP] Upgrade and install autoremove" >> $HOME/restore.log
    pip install --upgrade pip
    pip install pip-autoremove


# Install "loose" packages
    echo "[dpkg] Installing loose packages" >> $HOME/restore.log
    sleep 2
    cd /tmp/

    # Steam
    wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb && \
        dpkg -i steam.deb && echo "Steam OK" >> $HOME/restore.log

    # Chrome
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
        dpkg -i google-chrome-stable_current_amd64.deb && \
        echo "Chrome OK" >> $HOME/restore.log

    # playerctl
    wget https://github.com/acrisci/playerctl/releases/download/v0.5.0/playerctl-0.5.0_amd64.deb && \
        dpkg -i playerctl-0.5.0_amd64.deb && \
        echo "playerctl OK" >> $HOME/restore.log

    # Software
        mkdir $SOFTWARE_PATH && cd $_

        # PyCharm
            wget https://download.jetbrains.com/python/pycharm-professional-2016.2.tar.gz -O - | \
                tar xz
        # Arduino
            curl http://downloads.arduino.cc/arduino-1.6.10-linux64.tar.xz | \
                tar -xJ

        chown -R $SUDO_USER:$SUDO_USER $SOFTWARE_PATH

    # rofi v1.3.1
    wget https://github.com/DaveDavenport/rofi/releases/download/1.3.1/rofi-1.3.1.tar.gz && \
        tar xfz rofi-1.3.1.tar.gz && cd rofi-1.3.1 && ./configure && \
        make && make install

    # discord
    wget https://dl.discordapp.net/apps/linux/0.0.2/discord-0.0.2.deb -O discord.deb && \
        dpkg -i discord.deb

    # i3-gaps
    git clone https://www.github.com/Airblader/i3 i3-gaps && cd i3-gaps
    autoreconf --force --install
    rm -rf build/
    mkdir -p build && cd build/
    ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    make
    make install
    cd /tmp




# Fetch from GitHub
    # Oh My Zsh
    echo "Installing oh-my-zsh" >> $HOME/restore.log
    wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | \
        sh -


# Sublime Package Manager
    mkdir -p $HOME/.config/sublime-text-3/Installed\ Packages
    wget -O "$HOME/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package" \
        https://packagecontrol.io/Package%20Control.sublime-package


# Copy configs
    echo "Fetching dotfiles" >> $HOME/restore.log
    git clone https://github.com/husjon/dotfiles.git
    cp dunst $HOME/.config/
    cp i3 $HOME/.i3
    cp terminator $HOME/.config/
    cp Xresources $HOME/.Xresources
    cp zshrc $HOME/.zshrc



# Fonts
    echo "[font] installing fonts" >> $HOME/restore.log
    sleep 2
    mkdir $HOME/.fonts
    wget https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf -O \
        /usr/local/share/fonts/fontawesome-webfont.ttf
    fc-cache -f -v


# Theming
    wget http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/all/arc-theme_1488477732.766ae1a-0_all.deb -O \
    /tmp/arc-theme.deb
    dpkg -i /tmp/arc-theme.deb


# Tweaks
    echo "[Tweaks] Making minor tweaks." >> $HOME/restore.log
    sleep 2
    su $SUDO_USER bash -c 'gsettings set org.gnome.desktop.media-handling autorun-never true'             # Disables autorun of USB-disks and CD/DVD when mounted.
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences executable-text-activation ask'   # ask to run / display executable text files (f.ex .python, .sh)
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences enable-interactive-search false'  # Enable interactive search
    su $SUDO_USER bash -c 'gsettings set org.gnome.nautilus.preferences sort-directories-first true'      # Set Nautilus to sort folders first

    # Gnome Terminal Tweaks
    echo "[dconf] Gnome Terminal - Setting up profile."
    sleep 2
    PROFILE=$(dconf list /org/gnome/terminal/legacy/profiles:/)
    su $SUDO_USER bash -c "dconf write /org/gnome/terminal/legacy/profiles:/"$PROFILE"/background-color \"'rgb(43,48,59)'\""
    su $SUDO_USER bash -c "dconf write /org/gnome/terminal/legacy/profiles:/"$PROFILE"/foreground-color \"'rgb(192,197,206)'\""
    # xorg.conf
        wget https://u36847543.dl.dropboxusercontent.com/u/36847543/Ubuntu/xorg.conf -O /etc/X11/xorg.conf 


# Final message
    echo "Computer needs to be rebooted for the NVidia drivers to take effect"
    echo "Press CTRL+C to reboot later or "
    waitForInput
reboot
