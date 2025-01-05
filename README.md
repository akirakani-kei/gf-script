# gf-script
shell script that sends occasional screenshots of your system to your s.o. <br>
&nbsp; *(a fork of [inithook](https://github.com/akirakani-kei/inithook))*
<br>

![image](https://github.com/user-attachments/assets/94a57450-f820-4f9d-bccb-dabce56c8445)

## Installation

> [!IMPORTANT]
> *gf-script has the following dependencies:*
`curl maim xorg-server`; <br>
> *The script is meant to be installed and configured by the sender.*

> [!CAUTION]
> `maim`, the screenshot utility used in the script, does **NOT** support *Wayland.* <br>
> Since this tool's functionality is based on *screenshots*, I trust that you are _**proceeding with the installation process on a machine with a configured X11 display server.**_

##

### Install dependencies


Debian (Ubuntu, Mint, etc)
```shell
sudo apt install maim curl
```

Arch
```shell
sudo pacman -S maim curl
```

Fedora
```shell
sudo dnf install maim curl
```

openSUSE
```shell
sudo zypper install maim curl
```

##

### Run the installation script

```shell
sh -c "$(curl -sS https://raw.githubusercontent.com/akirakani-kei/gf-script/refs/heads/main/install.sh)"
```

<br>

## Paths

file                    |  path
------------------------|----------------------
gf-script.sh            | ~/.config/gf-script/gf-script.sh
gf-script.service       | ~/.config/systemd/user/gf-script.service
gfrc                    | ~/.config/gf-script/gf/gfrc

<br>

