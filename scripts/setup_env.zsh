#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"

if grep -i "debian" /etc/issue; then
    # update local repository
    sudo apt update

    # update all packages to latest versions
    sudo apt full-upgrade

    # programs to install with apt
    programs=( neofetch tmux tree vim zsh )

    for i in "${programs[@]}"
    do
        # check if program is already installed
        if command -v $i &> /dev/null; then
            echo "$i exists, skipping install"
        else
            echo "installing $i"

            # install using apt
            sudo apt install -y "$i"
        fi
    done


    # set zsh as the default shell
    if [ "$SHELL" != "/bin/zsh" ]; then
        echo "changing default shell to zsh"
        chsh -s /bin/zsh $USER
    else
        echo "Zsh already set as default shell."
    fi
elif grep -i "arch" /etc/issue; then
    # Update system packages
    sudo pacman -Syu --noconfirm

    # programs to install with pacman
    programs=( htop ncdu neofetch tmux tree vim zsh zsh-completions )

    for i in "${programs[@]}"
    do
        # check if program is already installed
        if command -v $i &> /dev/null; then
            echo "$i exists, skipping install"
        else
            echo "installing $i"

            # install using apt
            sudo pacman -S --noconfirm "$i"
        fi
    done

    # change default shell to Zsh
    if [ "$SHELL" != "/usr/bin/zsh" ]
    then
        echo "changing default shell to zsh"
        chsh -s /usr/bin/zsh $USER
    else
        echo "Zsh already set as default shell."
    fi
else
    echo "Distribution cannot be determined. No packages installed."
    exit 1
fi

# install zplug
if [ ! -d "$HOME/.zplug" ]
then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
    echo "Zplug already installed."
fi
