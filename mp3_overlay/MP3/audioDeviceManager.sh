#!/bin/sh
#This script is called in the background to check for audio output devices

#TODO: check if bluetooth is connected

#TODO: check if HDMI device is plugged
if [ hdmi device found ]; then
  amixer cset numid=3 2
  espeak -ven+f5 -s200 "HDMI connected" --stdout | aplay
#TODO: check if audio jack is plugged
elif [ audio device found ]; then
  amixer cset numid=3 1
  espeak -ven+f5 -s200 "Audio jack connected" --stdout | aplay
#TODO: if no device is plugged 
else
  echo '1' > /tmp/pause_flag
  espeak -ven+f5 -s200 "No audio device connected" --stdout | aplay 
fi
