# Raspberry Pi Dotfiles

## Restore instructions

There are some assumptions about the Pi being configured:

- It is being setup in headless mode
- It has already had an image installed
- SSH has been initialised in Raspberry Pi Imager configuration
- WiFi has been setup in Raspberry Pi Imager configuration

### Raspberry Pi Setup

The script below automates the following operations:

1. Generate SSH key
1. Start SSH agent and add the new key to the agent
1. Create an SSH configuration file with the correct permissions
1. Add the new key to the configuration file for use with Github

```sh
ssh-keygen -t ed25519 -C "39803787+simonward87@users.noreply.github.com"
eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519
pushd ~/.ssh/
touch config && chmod 600 config
cat >> config<< EOF
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
EOF
popd
```

Now copy the public key (`~/.ssh/id_ed25519.pub`), add to Github > Settings > SSH and GPG keys, and then test the SSH connection (`$ ssh -T git@github.com`). If successful, run the script below to clone this repository and navigate into the newly created directory. 

```sh
sudo apt update && sudo apt install -y git
git clone --recurse-submodules --jobs=8 git@github.com:simonward87/dotfiles-pi.git ~/.dotfiles
cd ~/.dotfiles
```

Confirm or adjust setup details in [`install.conf.yaml`](./install.conf.yaml), and finally, run `./install`.

### Local setup

For convenience, add an alias to `~/.ssh/config` (changing `NAME`, `USER` and `HOST` to device alias, username and IP address):

```
Host NAME
    User USER
    HostName HOST
    ServerAliveInterval 5
    TCPKeepAlive no
```

### Docker Setup

1. Uncomment the line below in `./install.conf` before running the install
   script (or just run the script directly)

```
# - command: ./scripts/setup_docker.zsh
```

### Desktop Setup (GNOME)

1. Uncomment the line below in `./install.conf` before running the install
   script (or just run the script directly)

```
# - command: ./scripts/setup_gnome.zsh
```

2. Run the desktop and login to get started

```sh
$ startx
```

3. Optionally, set the desktop environment to load on boot — run `raspi-config`,
   and then update the **boot / auto-login** settings to boot to desktop

```sh
$ sudo raspi-config
```

### Root User Config

If desired, symlink local config (e.g. `.vimrc`) to the root user directory:

```sh
$ sudo ln -s ~/.dotfiles/vimrc /root/.vimrc
$ sudo ln -s ~/.dotfiles/zshrc /root/.zshrc
$ sudo rm /root/.bashrc && sudo ln -s ~/.dotfiles/bashrc /root/.bashrc
```

### Setup PostgreSQL

```sh
$ sudo apt update && sudo apt full-upgrade -y
$ sudo apt install postgresql
$ sudo su postgres # Change to the postgres user 

$ createuser <username> -P --interactive # create a new role

$ psql
[psql]=# CREATE DATABASE <username>; # create new db matching username

[psql]=# \q # quit out from the CLI, and then from the default user

psql
CREATE DATABASE example;
\c example; " connect to new db
```

#### Setup remote access

```
$ psql -c 'SHOW hba_file;'
```

- Edit the hba file with superuser privileges
- At the end of the file, find IPv4 local connections
- Add an entry for the desired IP address, followed by `/32`
- Set the `METHOD` to `trust`:

```
# TYPE  DATABASE  USER  ADDRESS           METHOD
host    all       all   192.168.1.999/32  trust
```

- In the same directory as the hba file, edit `postgresql.conf`, and set `listen_addresses = '*'`
- Finally, restart the server:

```
$ sudo /etc/init.d/postgresql restart
```

### Manual Pi Initialisation

Most of these steps can be handled more easily through the Raspberry Pi Imager configuration – I've kept these notes here for reference.

1. Initialise SSH by placing an empty file named `ssh` in the root directory
2. [Setup WiFi](https://www.raspberrypi-spy.co.uk/2017/04/manually-setting-up-pi-wifi-using-wpa_supplicant-conf/) by configuring `wpa_supplicant.conf` and placing in the root directory
3. Once the pi is connected to your network, install your local machine public key to the remote Pi:

```sh
$ ssh-copy-id -i ~/.ssh/id_ed25520 USER@HOST
```


## Learning About Dotfiles

I learned a ton about [dotfiles, command line use, Homebrew, zsh, git, macOS and more with the course **_Dotfiles from Start to Finish-ish_**](http://dotfiles.eieio.xyz/) by [@EIEIOxyz](https://twitter.com/EIEIOxyz/).
