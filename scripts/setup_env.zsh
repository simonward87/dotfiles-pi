#!/bin/bash

echo -e "\n<<< Starting Environment Setup >>>\n"

sudo apt update
sudo apt full-upgrade
sudo apt install -y git tmux tree vim
