#!/bin/bash

echo -e "\n<<< Starting Neovim Setup >>>\n"

if command -v nvim &> /dev/null; then
    echo "neovim exists, skipping install"
else
    pushd ~

    git clone git@github.com:neovim/neovim.git && cd neovim
    git checkout stable

    # download and build all dependencies and put the nvim
    # executable in build/bin
    sudo make CMAKE_BUILD_TYPE=RelWithDebInfo

    # default install location is /usr/local
    sudo make install

    popd
fi

if command -v tree-sitter &> /dev/null; then
    echo "tree-sitter exists, skipping install"
else
    npm install --global tree-sitter-cli
fi
