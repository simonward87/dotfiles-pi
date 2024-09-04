# Raspberry Pi Dotfiles

## Restore instructions

There are some assumptions about the Pi being configured:

- It is being setup in headless mode
- It has already had an image installed
- SSH has been initialised in Raspberry Pi Imager configuration
- WiFi has been setup in Raspberry Pi Imager configuration

### Local setup before connecting

1. Install your local machine public key to the remote Pi:

```sh
$ ssh-copy-id -i ~/.ssh/id_ed25520 USER@HOST
```

2. Add an alias to `~/.ssh/config` (changing `USER` and `HOST` to username and IP address):

```
Host pi5
    User USER
    HostName HOST
    TCPKeepAlive no
```

### Raspberry Pi Setup

1. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh):

```sh
$ ssh-keygen -t ed25519 -C "39803787+simonward87@users.noreply.github.com"
```

2. Start `ssh-agent` and add the new key to the agent:

```sh
$ eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519
```

3. Create a configuration file in `~/.ssh` with `600` permissions:

```sh
$ touch ~/.ssh/config && chmod 600 ~/.ssh/config
```

4. Add the new key to the configuration file for use with Github:

```
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
```

5. Copy the public key (`~/.ssh/id_ed25519.pub`) and add to Github > Settings > SSH and GPG keys
6. Test SSH connection, then verify fingerprint and username:

```sh
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
$ ssh -T git@github.com
```

7. Update package info and install Git:

```sh
$ sudo apt update && sudo apt install -y git
```

8. Clone this repository:

```sh
$ git clone --recurse-submodules --jobs=8 git@github.com:simonward87/dotfiles-pi.git ~/.dotfiles && cd ~/.dotfiles
```

9. Confirm configuration details in `install.conf.yaml`, and finally, run [`./install`](install)

#### WiFi SSH Dropouts

When connecting over SSH, the connection always drops after a period of time, necessitating a reboot. This can be stopped by turning off `power_save` in `/etc/rc.local`. Add the line below, before `exit 0` is called:

```sh
/sbin/iwconfig wlan0 power off
```

It can also be manually disabled using `$ sudo iw wlan0 set power_save off`, although this will not persist.

| Note: |
| :--- |
| `/usr/sbin` currently has to be manually added to `PATH` for `iw` to function, as it is not included by default |

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

## Learning About Dotfiles

I learned a ton about [dotfiles, command line use, Homebrew, zsh, git, macOS and more with the course **_Dotfiles from Start to Finish-ish_**](http://dotfiles.eieio.xyz/) by [@EIEIOxyz](https://twitter.com/EIEIOxyz/).
