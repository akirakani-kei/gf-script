#!/bin/sh

if ! screencapture -x /tmp/perm_test.png; then
    osascript -e 'display alert "Screen recording access required." message "Go to System Settings > Privacy & Security > Screen Recording, toggle terminal/gf-script then reboot." as critical buttons {"OK"} default button "OK"'
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
  exit 1
fi
rm -f /tmp/perm_test.png

echo "waiting 10 seconds just to make sure bootup is finished and whether or not the user is logged in" 
sleep 10
    # not exactly urgent anyway

attempt=1
OKAY="true"

while true; do

  while [ $attempt -le 20 ]; do
    if ping -c 1 8.8.8.8 > /dev/null 2>&1 && [ -n "$(who | grep -E 'tty|pts')" ]; then
    
TOKEN=$(grep -E '^[^#]*token = ' $HOME/.config/gf-script/gfrc | sed 's/.*token = //')
CHANNEL_IDS=$(grep -E '^[^#]*channel-id = ' $HOME/.config/gf-script/gfrc | sed 's/.*channel-id = //')

if [ -z "$TOKEN" ]; then
    echo "err: token field cannot be empty. exiting. (see ~/.config/gf-script/gfrc or run the installation script again)"
    exit 1
fi

if [ -z "$CHANNEL_IDS" ]; then
    echo "err: channel id field cannot be empty. exiting. (see ~/.config/gf-script/gfrc or run the installation script again)"
    exit 1
fi

partner=$(grep -E '^[^#]*partner = ' $HOME/.config/gf-script/gfrc | sed 's/.*partner = //')
ping_id=$(grep -E '^[^#]*ping_id = ' $HOME/.config/gf-script/gfrc | sed 's/.*ping_id = //')
interval=$(grep -E '^[^#]*interval = ' $HOME/.config/gf-script/gfrc | sed 's/.*interval = //')

if [ "$interval" -lt 1 ]; then
  echo "invalid interval: must be at least 1 minute."
  exit 1
fi

### leaving these in here allows for live reassignment during the cooldown so why not

    case "$partner" in
        bf)
          term="boyfriend"
      pronoun="his"
          ;;
        gf)
          term="girlfriend"
      pronoun="her"
          ;;
        so)
          term="significant other"
      pronoun="their"
          ;;
        "")
          term="significant other"
      pronoun="their"
          ;;
        *)
          term="$partner"
      pronoun="their"
          ;;
      esac

    wakeup() {
    timestamp=$(date +%s)
    time=$(date +"%H:%M %Z")
    os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
    host_name=$(hostname)

    if [ "$os_name" = "darwin" ]; then
        os_name="darwin/macOS"
    fi 
        if [ -n "$ping_id" ]; then
            content="<@$ping_id>, your $term just turned on $pronoun pc! (\`$host_name\`, running \`$os_name\`, at: $time - <t:$timestamp:R>)
*you will receive your first screenshot in 5 minutes*"
        else
            content="<your $term just turned on $pronoun pc! (\`$host_name\`, running \`$os_name\`, at: $time - <t:$timestamp:R>)
*you will receive your first screenshot in 5 minutes*"
        fi
        for CHANNEL_ID in $CHANNEL_IDS; do
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null \
          --request POST \
            -H "Authorization: Bot $TOKEN" \
        -F "content=\"$content\"" \
        "https://discord.com/api/v10/channels/$CHANNEL_ID/messages")
        done
    
    if [ "$response" -ne 200 ]; then
        echo "err: failed to send wakeup message; most likely a matter of an invalid token or (one/multiple) channel id(s). HTTP response code: $response"
    exit 1
        else
            echo "Wakeup message successfully sent at $time. Waiting 5 minutes. (initial delay)"
    fi

    sleep 300
    }

      discordfunc() {
    
        timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
        timestamp2=$(date +%s)
        time=$(date +"%H:%M %Z")
        screenshot_path="$HOME/.config/gf-script/gfscript_$timestamp.png"
        screencapture -x "$screenshot_path"
    
    if [ -n "$ping_id" ]; then
        content="<@$ping_id>, here's what your $term is doing ($pronoun time: $time - <t:$timestamp2:R>)"
    else
        content="here's what your $term is doing ($pronoun time: $time - <t:$timestamp2:R>)"
    fi

        for CHANNEL_ID in $CHANNEL_IDS; do
    response=$(curl --write-out "%{http_code}" --silent --output /dev/null \
          --request POST \
            -H "Authorization: Bot $TOKEN" \
        -F "content=\"$content\"" \
            -F "file=@$screenshot_path" \
        "https://discord.com/api/v10/channels/$CHANNEL_ID/messages")
        done

    if [ "$response" -ne 200 ]; then
        echo "err: failed to send message; most likely a matter of an invalid token or (one/multiple) channel id(s). HTTP response code: $response"
        rm -f "$screenshot_path"
        exit 1
        else
        echo "Screenshot successfully sent at $time. Waiting $interval minute(s)."
    fi

    sleep 15 # waiting 15 seconds to delete the screenshot to make sure the message went through
        rm "$screenshot_path"
      }

    if [ "$OKAY" = "true" ]; then
        wakeup
    OKAY="false"
    fi

      discordfunc

      sleep $((interval * 60 - 15))

    else

      echo "Waiting for internet connection. Failed after $attempt attempts."

      attempt=$((attempt + 1))
      
      sleep 5

      if [ $attempt -gt 20 ]; then
        exit 1
      fi
    fi

  done

done
