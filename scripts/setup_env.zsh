#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"
echo -e "Enter superuser (sudo) password to install programmes"

sudo apt update
sudo apt full-upgrade
sudo apt install -y neofetch tmux tree vim zsh

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# set zsh as the default shell
chsh -s /bin/zsh
