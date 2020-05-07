#!/bin/sh
#This script is called in the background to check for audio output devices

#Call Bluetooth initialization script
sh /MP3/startBluetooth.sh
sleep 20

#Continuously check for new audio devices, with priority Bluetooth --> HDMI --> Audio jack
while :
do
    
    sleep 2
    bluetooth_flag=`bluetoothctl info XX:XX:XX:XX:XX:XX | grep "Connected:\ yes"`
    hdmi_flag=`tvservice -n | grep -c "device_name"`

    #Check if Bluetooth is connected
    if [ $bluetooth_flag -ne 0 ]; then
      amixer cset numid=3 1 

    #Check if HDMI device is plugged
    elif [ $hdmi_flag -ne 0 ]; then
      if [ `tvservice -s | grep -c "0x12000a"` -eq 0 ]; then
        tvservice -p
      fi
      amixer cset numid=3 2

    #Audio jack is default
    else
      amixer cset numid=3 1

    fi

    #TODO: if no device is plugged, pause the song
    #TODO: when device is changed, inform user via espeak

done
