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
8. [Generate ssh key](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), add to GitHub, and switch remotes.

```sh
ssh-keygen -t ed25519 -C "39803787+simonward87@users.noreply.github.com"
```

9. Start `ssh-agent`, and then add the new key to the agent

```sh
eval $(ssh-agent)

ssh-add ~/.ssh/id_ed25519
```

10. Create a config file in `~/.ssh` with `600` permissions

```sh
touch ~/.ssh/config && chmod 600 ~/.ssh/config
```

11. Add the new key so it is used for Github

```
Host github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
```

12. Make a copy of the public key (`~/.ssh/id_ed25519.pub`) and add to Github > Settings > SSH and GPG keys
13. Test SSH connection, then verify fingerprint and username

```sh
# https://help.github.com/en/github/authenticating-to-github/testing-your-ssh-connection
ssh -T git@github.com
```

14. Finally, navigate to `~/.dotfiles`, and set the remote to use SSH

```sh
git remote set-url origin git@github.com:simonward87/dotfiles-pi.git
```
