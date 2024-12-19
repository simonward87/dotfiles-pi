#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"

# programs to install
programs=( curl fd-find gzip htop ncdu neofetch ripgrep ruby tar tldr tmux tree unzip vim zsh )

if grep -i "debian" /etc/issue &> /dev/null; then
    # update local repository
    sudo apt update

    # update all packages to latest versions
    sudo apt full-upgrade -y

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
        echo -e "\nChanging default shell to zsh\n"
        sudo chsh -s /bin/zsh $USER
    else
        echo -e "\nzsh already set as default shell\n"
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

    # setup tldr cache dir
    if [! -d "~/.local/share/tldr"]; then
        mkdir -p ~/.local/share/tldr
    fi

    # update tldr cache
    tldr -u

    # change default shell to Zsh
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        echo -e "\nChanging default shell to zsh\n"
        chsh -s /usr/bin/zsh $USER
    else
        echo -e "\nzsh already set as default shell\n"
    fi
else
    echo -e "\nDistribution cannot be determined — no packages installed\n"
    exit 1
fi

# install zplug
if [ ! -d "$HOME/.zplug" ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
else
    echo "zplug exists, skipping install"
fi

if command -v fd &> /dev/null; then
    echo "fd exists, skipping symlinking"
else
    if [ ! -d "$HOME/.local/bin" ]; then
        mkdir -p $HOME/.local/bin
    fi

    ln -s $(which fdfind) ~/.local/bin/fd
fi
