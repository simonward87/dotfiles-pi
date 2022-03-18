#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"
echo -e "Enter superuser (sudo) password to install programmes"

# update local repository
sudo apt update

# update all packages to latest versions
sudo apt full-upgrade

# programs to install
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

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# set zsh as the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "changing default shell to zsh"
    chsh -s /bin/zsh
fi
