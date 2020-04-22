#!/bin/sh
#This script is called in the background to check for audio output devices

#Call initialization script
sh /MP3/startBluetooth.sh


#Continuously check for new audio devices, with priority Bluetooth --> HDMI --> Audio jack
while :
do
    #TODO: check if bluetooth is connected
    if [ bluetooth is connected ]; then
      espeak -ven+f5 -s200 "Bluetooth connected" --stdout | paplay
    #TODO: check if HDMI device is plugged
    elif [ hdmi device found ]; then
      amixer cset numid=3 2
      espeak -ven+f5 -s200 "HDMI connected" --stdout | aplay
    #TODO: check if audio jack is plugged
    elif [ audio device found ]; then
      amixer cset numid=3 1
      espeak -ven+f5 -s200 "Audio jack connected" --stdout | aplay
    #TODO: if no device is plugged 
    else
      echo '1' > /tmp/pause_flag 
    fi
done
