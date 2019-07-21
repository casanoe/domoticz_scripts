#!/bin/sh
# Bose Soundtouch on/off
#
# Parameter 1 is the IP address
# Parameter 2 is 'on' or 'off'
# If parameter 2 is empty, the script return 'on' and 0 as exit code; exit code 1 otherwise

if [ "$1" = "" ]; then
	echo "Parameter 1 is the IP Address of your speaker"
	exit
fi
	
host=$1:8090

state=$(curl http://$host/now_playing | grep -cv "STANDBY") 2>/dev/null

if [[ "$2" = "on" && $state -eq 0 ]] || [[ "$2" = "off" && $state -ge 1 ]]; then
	curl --request POST --header "Content-Type: application/xml" --data ' <key state="press" sender="Gabbo">POWER</key> ' http://$host/key
else
	if [ $state -ge 1 ]; then
		echo "on"
		exit 0
	fi
	exit 1
fi