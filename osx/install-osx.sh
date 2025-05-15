#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
    printf "please run me as a normal user, not root!\n"
    exit 1
fi

printf "\n"
printf "gf-script macOS INSTALLATION SETUP\n"
printf "\n"

launchctl unload ~/Library/LaunchAgents/com.user.gfscript.plist 2>/dev/null
rm -rf ~/.config/gf-script 
rm ~/Library/LaunchAgents/com.user.gfscript.plist 

git clone https://github.com/akirakani-kei/gf-script/
cd gf-script/osx
sed -i '' "s/kei/$(whoami)/g" com.user.gfscript.plist
chmod +x gf-script-osx.sh
chmod 644 com.user.gfscript.plist

mkdir -p ~/.config/gf-script/ 
mkdir -p ~/Library/LaunchAgents/ # idk if this is system generated or not lol

mv -f gf-script-osx.sh ~/.config/gf-script/gf-script.sh
mv -f com.user.gfscript.plist ~/Library/LaunchAgents 

cd ..
mv gfrc ~/.config/gf-script/ 


printf "Enter Discord Client Token (found at: https://discord.com/developers/applications): "
read token
printf "Enter Discord Channel ID (right click on wanted channel, click on Copy Channel ID): "
read channel_id

sed -i "/^[^#]*token =/s/token =.*/token = $token/" "~/.config/gf-script/gfrc"
sed -i "/^[^#]*channel-id =/s/channel-id =.*/channel-id = $channel_id/" "~/.config/gf-script/gfrc"

printf "Select partner format:\n"
printf "(bf, gf, so, custom): "
read format_choice
sed -i "/^[^#]*partner =/s/partner =.*/partner = $format_choice/" "~/.config/gf-script/gfrc"

printf "How often do you want the alerts to be sent? (default is 15, enter to skip)\n"
printf "Value CAN'T be lower than 1 (script won't run)\n"
printf "interval (in minutes): "
read interval
interval=${interval:-15}
sed -i "/^[^#]*interval =/s/interval =.*/interval = $interval/" "~/.config/gf-script/gfrc"

printf "Would you like your s.o. to get a ping with every alert? [Y/n]: "
read prompt

prompt="${prompt:-Y}"
prompt=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')

if [ "$prompt" = "y" ]; then
    printf "Enter User ID (right click on user, click copy user id): "
    read ping_id
    sed -i "/^[^#]*ping_id =/s/ping_id =.*/ping_id = $ping_id/" "~/.config/gf-script/gfrc"
fi

cd ..
rm -rf gf-script 

launchctl load ~/Library/LaunchAgents/com.user.gfscript.plist
launchctl start com.user.gfscript.plist

printf "Installation sucessful.\n"
