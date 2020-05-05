#!/bin/sh
#This script is called in the background to check for audio output devices

#Add root to pulse-access if not already added
sed -i "/^pulse-access:x:[[:digit:]]*:pulse$/ s/$/,root/" /etc/group 2&> /dev/null

#Call Bluetooth initialization script
sh /MP3/startBluetooth.sh
sleep 20

#Continuously check for new audio devices, with priority Bluetooth --> HDMI --> Audio jack
while :
do
    
    sleep 5
    hdmi_flag=`tvservice -n | grep -c HDMI`
	bluetooth_flag=`bluetoothctl info | grep -c "Connected:\ yes"`

    #Check if bluetooth is connected
    if [ $bluetooth_flag -ne 0 ]; then
      #espeak -ven+f5 -s200 "Bluetooth connected" --stdout | paplay

    #Check if HDMI device is plugged
    elif [ $hdmi_flag -ne 0 ]; then
      tvservice -p
      amixer cset numid=3 2
      #espeak -ven+f5 -s200 "HDMI connected" --stdout | aplay

    #Audio jack is default
    else
      amixer cset numid=3 1
      #espeak -ven+f5 -s200 "Audio jack connected" --stdout | aplay

    #TODO: if no device is plugged 
    #else
      #echo '1' > /tmp/pause_flag
      #espeak -ven+f5 -s200 "No audio device connected" --stdout | aplay 
    fi
done
