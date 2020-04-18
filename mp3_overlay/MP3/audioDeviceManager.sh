#!/bin/sh

if [ hdmi device found ]; then
  amixer cset numid=3 2
  espeak -ven+f5 -s200 "HDMI connected" --stdout | aplay
elif [ audio device found ]; then
  amixer cset numid=3 1
  espeak -ven+f5 -s200 "Audio jack connected" --stdout | aplay 
else
  echo '1' > /tmp/pause_flag
  espeak -ven+f5 -s200 "No audio device connected" --stdout | aplay 
fi
