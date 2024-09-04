#!/bin/bash

echo -e "\n<<< Starting Docker Setup >>>\n"
echo -e "Enter superuser (sudo) password to continue with installation"

if command -v docker &> /dev/null; then
    echo "docker exists, skipping install"
else
    # install docker
    curl -sSL https://get.docker.com | sh

    # add user to docker group
    sudo usermod -aG docker ${USER}

    # run docker daemon on startup
    sudo systemctl enable docker
fi

echo -e "\n<<< Reboot to start the docker daemon >>>\n"
