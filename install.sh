#!/bin/sh

printf "\n"
printf "gf-script INSTALLATION SETUP\n"
printf "\n"

if [ "$(id -u)" -eq 0 ]; then
    printf "please run me as a normal user, not root!\n"
    exit 1
fi

rm -rf ~/.config/gf-script
rm -f ~/.config/systemd/user/gf-script.service

git clone https://github.com/akirakani-kei/gf-script
cd gf-script

mkdir -p ~/.config/systemd ~/.config/systemd/user ~/.config/gf-script
mv gf-script.sh ~/.config/gf-script
mv gfrc ~/.config/gf-script/
mv gf-script.service ~/.config/systemd/user/
chmod +x ~/.config/gf-script/gf-script.sh
systemctl --user enable gf-script.service
cd ..
rm -rf gf-script

printf "Enter Discord Client Token (found at: https://discord.com/developers/applications): "
read token
printf "Enter Discord Channel ID (right click on wanted channel, click on Copy Channel ID): "
read channel_id

sed -i "/^[^#]*token =/s/token =.*/token = $token/" "$HOME/.config/gf-script/gfrc"
sed -i "/^[^#]*channel-id =/s/channel-id =.*/channel-id = $channel_id/" "$HOME/.config/gf-script/gfrc"

printf "Select partner format:\n"
printf "(bf, gf, so, custom): "
read format_choice
sed -i "/^[^#]*partner =/s/partner =.*/partner = $format_choice/" "$HOME/.config/gf-script/gfrc"

printf "How often do you want the alerts to be sent? (default is 15, enter to skip)\n"
printf "interval (in minutes): "
read interval
interval=${interval:-15}
sed -i "/^[^#]*interval =/s/interval =.*/interval = $interval/" "$HOME/.config/gf-script/gfrc"

printf "Would you like your s.o. to get a ping with every alert? [Y/n]: "
read prompt

prompt="${prompt:-Y}"
prompt=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

if [ "$prompt" = "y" ]; then
    printf "Enter User ID (right click on user, click copy user id): "
    read ping_id
    sed -i "/^[^#]*ping_id =/s/ping_id =.*/ping_id = $ping_id/" "$HOME/.config/gf-script/gfrc"
fi

printf "Installation successful. Modify ~/.config/gf-script/gfrc for further configuration.\n"
