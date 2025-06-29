![image](https://github.com/user-attachments/assets/8a221144-15c2-4b38-82d3-2393f59a1ece) <br>
shell script that sends occasional screenshots of your system to your s.o. <br>
&nbsp; *(a fork of [inithook](https://github.com/akirakani-kei/inithook))*
<br>

![image](https://github.com/user-attachments/assets/a3b23b9d-b0dc-4993-b345-d47318c3245a)


<br>

<div align = center>
  
&ensp;[<kbd> <br> About <br> </kbd>](#)&ensp;
&ensp;[<kbd> <br> Features <br> </kbd>](#Features)&ensp;
&ensp;[<kbd> <br> Installation <br> </kbd>](#Installation)&ensp;
&ensp;[<kbd> <br> Paths <br> </kbd>](#Paths)&ensp;

</div>

## Features
- highly customisable!
- discord webhook integration (no hosting required, runs as background systemd process)
- term / pronoun support (bf, gf, s.o., etc.)
- send alerts to multiple channels at once
- custom time interval (choose how often the screenshots are sent)
- dynamic configuration (change settings without needing to restart)

|              Mentions OFF                                                                 |             Mentions ON                                                                   |
| :---------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------: |
| ![image](https://github.com/user-attachments/assets/f7627d8c-b254-4498-a871-f4c8243c56bc) | ![image](https://github.com/user-attachments/assets/ca804686-c8ed-496e-9049-0d72e599940a) |

## Installation

> [!IMPORTANT]
> *gf-script has the following dependencies:*
`curl maim xorg-server` <br>
> *It is meant to be installed and configured by the sender.* <br>
> *The script runs as a systemd **user** process and should be interacted with via the `--user` tag:* <br>
`systemctl --user status gf-script`

> [!CAUTION]
> `maim`, the screenshot utility used in the script, does **NOT** support *Wayland.* <br>
> Since this tool's functionality is based on *screenshots*, I trust that you are _**proceeding with the installation process on a machine with a configured X11 display server.**_

##

### Install dependencies


Debian (Ubuntu, Mint, etc.)
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

### Create a Discord Application

Go to *[Discord's Developer Portal](https://discord.com/developers/applications)* and **[create a new application](https://discordjs.guide/preparations/setting-up-a-bot-application.html#creating-your-bot)** (or use an already existing one) which will serve as a mean of connection to Discord.
<br> <br>
***Copy the token and save it for later.***

*[Add your bot to the server](https://discordjs.guide/preparations/adding-your-bot-to-servers.html#bot-invite-links)* you want the alerts to go on ([create a server](https://support.discord.com/hc/en-us/articles/204849977-How-do-I-create-a-server) if you haven't already).
<br> <br>
***Also copy the Channel ID(s) you want the screenshots to be sent to and save them.*** <br>
<sub> Make sure your bot has the necessary permissions to access/send messages to those channels! <br>

<br>

**BONUS:** Copy your s.o.'s User ID if you want them to receive a ping with every alert *(you will be prompted about this during the installation script).*

![image](https://github.com/user-attachments/assets/497a608c-d3fe-401b-9259-bd8978ccc482)
<sub> &nbsp; &nbsp; *right click their profile, click **Copy User ID***

##

### Run the installation script

```shell
sh -c "$(curl -sS https://raw.githubusercontent.com/akirakani-kei/gf-script/refs/heads/main/install.sh)"
```
_Paste the previously **[saved information](#create-a-discord-application)** accordingly; configure based on your own preferences._ <br>
After installation, reboot or run `systemctl --user start gf-script`. <br> <br>
*See `~/.config/gf-script/gfrc` for further configuration.*
<br> <br> <br>
Enjoy~!
<br>


## Paths

file                    |  path
------------------------|----------------------
gf-script.sh            | ~/.config/gf-script/gf-script.sh
gf-script.service       | ~/.config/systemd/user/gf-script.service
gfrc                    | ~/.config/gf-script/gf/gfrc

<br>

<sub> *dedicated to my curious little girlfriend (i do run this myself)*
