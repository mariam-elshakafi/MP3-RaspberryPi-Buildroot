#!/bin/sh
#This script is a scheduler that initializes, and calls other scripts necessary to run mp3.

#Load sound card driver
driverLoadedFlag=`lsmod | grep snd_bcm2835 | wc -w`
if [ $driverLoadedFlag -eq 0 ]; then
  modprobe snd-bcm2835
fi

#Initializing execution flags used in mp3 player script mp3Start.sh
echo '0' > /tmp/clear_flag
echo '0' > /tmp/start_flag                      
echo '0' > /tmp/stop_on_next_click      
echo '0' > /tmp/next_flag                        
echo '0' > /tmp/prev_flag                        
echo '0' > /tmp/restart_flag
echo '0' > /tmp/pause_flag
echo '0' > /tmp/shuf_flag  
echo '0' > /tmp/prevButtonPressed          
echo '0' > /tmp/prevTimeCount  
echo '1' > /tmp/songNum
echo 'Welcome to MP3!' > /tmp/mp3_state

#Initializing buttons
echo "2" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio2/direction 2> /dev/null

echo "3" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio3/direction 2> /dev/null

echo "4" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio4/direction 2> /dev/null

echo "17" > /sys/class/gpio/export 2> /dev/null
echo "in" > /sys/class/gpio/gpio17/direction 2> /dev/null

#Initializing song list
songsFile=/Songs/songList
find /Songs -name '*.mp3' > $songsFile

#Main execution loop
while :
do
    sh /MP3/mp3Start.sh
    sleep 0.2
done
