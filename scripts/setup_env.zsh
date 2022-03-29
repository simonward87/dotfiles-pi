#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"

# programs to install with pacman
programs=( htop ncdu neofetch tmux tree vim zsh )

if grep -i "debian" /etc/issue &> /dev/null; then
    # update local repository
    sudo apt update

    # update all packages to latest versions
    sudo apt full-upgrade

    for i in "${programs[@]}"
    do
        # check if program is already installed
        if command -v $i &> /dev/null; then
            echo "$i exists, skipping install"
        else
            # install using apt
            sudo apt install -y "$i"
        fi
    done


    # set zsh as the default shell
    if [ "$SHELL" != "/bin/zsh" ]; then
        echo "Changing default shell to zsh"
        chsh -s /bin/zsh $USER
    else
        echo "Zsh already set as default shell"
    fi
elif grep -i "arch" /etc/issue &> /dev/null; then
    # Update system packages
    sudo pacman -Syu --noconfirm

    for i in "${programs[@]}"
    do
        # check if program is already installed
        if command -v $i &> /dev/null; then
            echo "$i exists, skipping install"
        else
            # install using pacman
            sudo pacman -S --noconfirm "$i"
        fi
    done

    # change default shell to Zsh
    if [ "$SHELL" != "/usr/bin/zsh" ]
    then
        echo "Changing default shell to zsh"
        chsh -s /usr/bin/zsh $USER
    else
        echo "zsh already set as default shell"
    fi
else
    echo "Distribution cannot be determined — no packages installed"
    exit 1
fi

# install zplug
if [ ! -d "$HOME/.zplug" ]
then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
    echo "zplug exists, skipping install"
fi
