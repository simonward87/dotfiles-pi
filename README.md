# Raspberry Pi Dotfiles

I learned a ton about [dotfiles, command line use, Homebrew, zsh, git, macOS and more with the course **_Dotfiles from Start to Finish-ish_**](http://dotfiles.eieio.xyz/) by [@EIEIOxyz](https://twitter.com/EIEIOxyz/), and you can too!

## Restore Instructions

There are some assumptions about the Pi being configured: 

- It is being setup in headless mode
- It has already had an image installed
- SSH has been initialised (placing an empty file named `ssh` in the root directory)
- WiFi has been setup (configuring `wpa_supplicant.conf` and placing in the root directory)
- You have successfully connected via SSH and are logged in as the default user

1. Setup a new user and password, and assign permissions

```sh
sudo adduser USERNAME
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi USERNAME
```

2. Change to the new user, and then update the **boot / auto-login** settings to use this new user

```sh
sudo su - USERNAME
sudo raspi-config
```

3. End the remote session and copy local ssh id to the Pi. Consider adding an alias of the remote to local ssh config file for fast access

```sh
ssh-copy-id -i ~/.ssh/id_ed25519 USERNAME@HOSTADRESS
```

4. Reconnect as the new user, remove the default user

```sh
sudo deluser -remove-home pi
```

5. Update package info, upgrade outdated packages if required and install git

```sh
sudo apt update
sudo apt full-upgrade
sudo apt install -y git
```

6. Clone this repository. Use `https` for now, switch to `ssh` later

```sh
git clone https://github.com/simonward87/dotfiles-pi.git ~/.dotfiles
```

7. `cd ~/.dotfiles`
8. [`./install`](install)
9. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

```sh
ssh-keygen -t ed25519 -C "39803787+simonward87@users.noreply.github.com"

# If required, start the ssh-agent
eval "$(ssh-agent -s)"
```

10. Copy public key and add to github.com > Settings > SSH and GPG keys (`~/.ssh/id_ed25519.pub`)
11. Test SSH connection, then verify fingerprint and username

```sh
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
ssh -T git@github.com
```

12. Navigate back to `~/.dotfiles`, and switch from HTTPS to SSH

```sh
git remote set-url origin git@github.com:simonward87/dotfiles-pi.git
```
