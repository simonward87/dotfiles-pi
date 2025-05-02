#!/bin/bash

if command -v caddy &> /dev/null; then
    echo "caddy exists, skipping install"
else
    sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
    sudo apt update
    sudo apt install caddy
fi

# Configuration file:
# $ sudo vi /etc/caddy/Caddyfile
#
# Place static files in either /var/www/html or /srv. Ensure caddy has
# permission to read the files.
#
# Verify the service is running:
# $ systemctl status caddy
#
# Read full logs and to avoid lines being truncated:
# $ journalctl -u caddy --no-pager | less +G
#
# Gracefully reload Caddy config file after making changes:
# $ sudo systemctl reload caddy
#
# Stop service:
# $ sudo systemctl stop caddy
