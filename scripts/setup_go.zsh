#!/bin/bash

echo -e "\n<<< Starting Go Setup >>>\n"

if command -v go &> /dev/null; then
    echo "go exists, skipping install"
else
    INSTALL_FILE=`$HOME/.dotfiles/bin/scrape`

    curl -LO https://go.dev/dl/$INSTALL_FILE
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf $INSTALL_FILE
    rm $INSTALL_FILE

    if command -v dlv &> /dev/null; then
        echo "dlv exists, skipping install"
    else
        go install github.com/go-delve/delve/cmd/dlv@latest
    fi

    if command -v gomodifytags  &> /dev/null; then
        echo "gomodifytags exists, skipping install"
    else
        go install github.com/fatih/gomodifytags@latest
    fi

    if command -v gotests &> /dev/null; then
        echo "gotests exists, skipping install"
    else
        go install github.com/cweill/gotests/gotests@latest 
    fi

    if command -v impl &> /dev/null; then
        echo "impl exists, skipping install"
    else
        go install github.com/josharian/impl@latest
    fi
fi
