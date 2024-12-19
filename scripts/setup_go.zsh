#!/bin/bash

echo -e "\n<<< Starting Go Setup >>>\n"

if command -v go &> /dev/null; then
    echo "go exists, skipping install"
else
    INSTALL_FILE="go1.23.4.linux-arm64.tar.gz"

    if grep -i "debian" /etc/issue &> /dev/null; then
        INSTALL_FILE=`$HOME/.dotfiles/bin/scrape`
    fi

    curl -LO https://go.dev/dl/$INSTALL_FILE
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf $INSTALL_FILE
    rm $INSTALL_FILE
fi
