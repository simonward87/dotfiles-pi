#!/bin/bash

echo -e "\n<<< Starting Node Setup >>>\n"

if command -v node &> /dev/null; then
    echo "node exists, skipping install"
else
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n \
        | sudo bash -s install lts
    # If you want n installed, you can use npm now.
    npm install -g n
fi
