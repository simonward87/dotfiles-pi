# Raspberry Pi Dotfiles

I learned a ton about
[dotfiles, command line use, Homebrew, zsh, git, macOS and more with the course **_Dotfiles from Start to Finish-ish_**](http://dotfiles.eieio.xyz/)
by [@EIEIOxyz](https://twitter.com/EIEIOxyz/), and you can too!

## Restore Instructions

There are some assumptions about the Pi being configured:

- It is being setup in headless mode
- It has already had an image installed
- SSH has been initialised (placing an empty file named `ssh` in the root
  directory)
- WiFi has been setup (configuring `wpa_supplicant.conf` and placing in the root
  directory)
- You have successfully connected via SSH and are logged in as the default user

1. Setup a new user and password, and assign permissions

```sh
sudo adduser USERNAME
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi USERNAME
```

2. Change to the new user, and then update the **boot / auto-login** settings to
   use this new user

```sh
sudo su - USERNAME
sudo raspi-config
```

3. The previous step ends the remote session on reboot. Copy local ssh id to the
   Pi. Consider adding an alias of the remote to local ssh config file for fast
   access

```sh
ssh-copy-id -i ~/.ssh/id_ed25519 USER@HOST
```

4. Reconnect as the new user and remove the default user

```sh
sudo deluser -remove-home pi
```

5. Update package info and install git

```sh
sudo apt update
sudo apt install -y git
```

6. Clone this repository. Use `https` for now, switch to `ssh` later

```sh
git clone https://github.com/simonward87/dotfiles-pi.git ~/.dotfiles && cd ~/.dotfiles
```

7. [`./install`](install)

### SSH Setup

1. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh),
   add to GitHub, and switch remotes.

```sh
ssh-keygen -t ed25519 -C "39803787+simonward87@users.noreply.github.com"
```

2. Start `ssh-agent`, and then add the new key to the agent

```sh
eval $(ssh-agent)

ssh-add ~/.ssh/id_ed25519
```

3. Create a config file in `~/.ssh` with `600` permissions

```sh
touch ~/.ssh/config && chmod 600 ~/.ssh/config
```

4. Add the new key so it is used for Github

```
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
```

5. Make a copy of the public key (`~/.ssh/id_ed25519.pub`) and add to Github >
   Settings > SSH and GPG keys
6. Test SSH connection, then verify fingerprint and username

```sh
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
ssh -T git@github.com
```

7. Finally, navigate to `~/.dotfiles`, and set the remote to use SSH

```sh
git remote set-url origin git@github.com:simonward87/dotfiles-pi.git
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
startx
```

3. Optionally, set the desktop environment to load on boot ??? run `raspi-config`,
   and then update the **boot / auto-login** settings to boot to desktop

```sh
sudo raspi-config
```

### WiFi SSH Dropouts

When connecting over SSH, the connection always drops after a period of time, necessitating a reboot. This can be fixed by turning off `power_save` in `/etc/rc.local`. Add the line below, before `exit 0` is called:

```
/sbin/iwconfig wlan0 power off
```

It can also be manually disabled using `sudo iw wlan0 set power_save off`, although this will not persist.

| Note: |
| :--- |
| `/usr/sbin` currently has to be manually added to `PATH` for `iw` to function, as it is not included by default |
