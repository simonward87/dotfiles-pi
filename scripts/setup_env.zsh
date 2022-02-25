#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"
echo -e "Enter superuser (sudo) password to install programmes"

sudo apt update
sudo apt full-upgrade
sudo apt install -y tmux tree vim
