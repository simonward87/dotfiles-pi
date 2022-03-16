#!/bin/bash

echo -e "\n<<< Starting Docker Setup >>>\n"
echo -e "Enter superuser (sudo) password to continue with installation"

if command -v docker &> /dev/null; then
    echo "docker-compose exists, skipping install"
else
    # install docker
    curl -sSL https://get.docker.com | sh

    # add user to docker group
    sudo usermod -aG docker ${USER}

    # run docker daemon on startup
    sudo systemctl enable docker
fi

if command -v docker-compose &> /dev/null; then
    echo "docker-compose exists, skipping install"
else
    # install pip3 so docker-compose can be installed
    sudo apt install -y python3-pip

    # use pip3 to install docker-compose
    sudo pip3 install docker-compose
fi

echo -e "\n<<< Reboot to start the docker daemon >>>\n"
