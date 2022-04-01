#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"

if grep -i "debian" /etc/issue &> /dev/null; then
    # update local repository
    sudo apt update

    sudo apt install -y xorg gnome gnome-shell --no-install-recommends
elif grep -i "arch" /etc/issue &> /dev/null; then
    # Update system packages
    sudo pacman -Syu --noconfirm

    sudo pacman -S xorg gnome gnome-shell
else
    echo -e "\nDistribution cannot be determined — no packages installed\n"
    exit 1
fi

sudo systemctl disable dhcpcd
sudo /etc/init.d/dhcpcd stop
sudo reboot
