#!/bin/sh

currentState=`cat /tmp/mp3_state`
clear
echo "Welcome to MP3!"
sleep 1
clear
echo $currentState

while :
do

    sh /MP3/readInputs.sh
    if [ "$currentState" != "`cat /tmp/mp3_state`" ]; then
      currentState=`cat /tmp/mp3_state`
      clear
      echo $currentState
    fi
    
done
