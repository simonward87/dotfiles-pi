#!/bin/bash

echo -e "\n<<< Starting Go Setup >>>\n"

if command -v go &> /dev/null; then
    echo "go exists, skipping install"
else
    curl -LO https://go.dev/dl/go1.23.0.linux-arm64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
    rm go1.23.0.linux-amd64.tar.gz

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
