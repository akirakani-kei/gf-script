#!/bin/sh

sleep 10 # just to make sure bootup is finished and figuring out the user works
	# not exactly urgent anyway

attempt=1
OKAY="true"


while true; do

  while [ $attempt -le 20 ]; do
    if ping -c 1 8.8.8.8 &> /dev/null && [ -n "$(who | grep -E 'tty|pts')" ]; then
	
TOKEN=$(grep -oP '^(?!#).*token = \K.*' /home/$(who | awk 'NR==1{print $1}')/.config/gf-script/gfrc)
CHANNEL_IDS=$(grep -oP '^(?!#).*channel-id = \K.*' /home/$(who | awk 'NR==1{print $1}')/.config/gf-script/gfrc)

partner=$(grep -oP '^(?!#).*partner = \K.*' /home/$(who | awk 'NR==1{print $1}')/.config/gf-script/gfrc)
ping_id=$(grep -oP '^(?!#).*ping_id = \K.*' /home/$(who | awk 'NR==1{print $1}')/.config/gf-script/gfrc)
interval=$(grep -oP '^(?!#).*interval = \K.*' /home/$(who | awk 'NR==1{print $1}')/.config/gf-script/gfrc)

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


	time=$(date +"%H:%M")

	wakeup() {
		if [ -n "$ping_id" ]; then
            content="<@$ping_id>, your $term just turned on $pronoun pc! ($time)"
          else
            content="your $term just turned on $pronoun pc! ($time)"
          fi
        for CHANNEL_ID in $CHANNEL_IDS; do
          curl --request POST \
            -H "Authorization: Bot $TOKEN" \
	    -F "content=\"$content\"" \
            "https://discord.com/api/v10/channels/$CHANNEL_ID/messages"
        done
	sleep 10
	}

      discordfunc() {

        timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
        screenshot_path="$HOME/.config/gf-script/gfscript_$timestamp.png"
        maim "$screenshot_path"
	
	if [ -n "$ping_id" ]; then
		content="<@$ping_id>, here's what your $term is doing ($pronoun time: $time)"
	else
            	content="here's what your $term is doing ($pronoun time: $time)"
	fi

        for CHANNEL_ID in $CHANNEL_IDS; do
          curl --request POST \
            -H "Authorization: Bot $TOKEN" \
	    -F "content=\"$content\"" \
            -F "file=@$screenshot_path" \
            "https://discord.com/api/v10/channels/$CHANNEL_ID/messages"
        done
	
	echo "Screenshot successfully sent at $time. Waiting $interval minute(s)."
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
