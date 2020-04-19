#!/bin/sh
#This script is to be used for initializing Bluetooth.

#Bringing up the Bluetooth interface
hciattach /dev/ttyAMA0 bcm43xx 115200 noflow
sleep 0.2
modprobe hci_uart
modprobe btusb
hciconfig hci0 up
sleep 0.2
/usr/libexec/bluetooth/bluetoothd &
sleep 0.2 

#Start jackd sound server so ALSA won't bring PulseAudio down
jackd -d alsa &

#When system is powered, power on Bluetooth, and try connecting
bluetoothctl power on
bluetoothctl pairable on
bluetoothctl pair XX:XX:XX:XX:XX:XX
bluetoothctl connect XX:XX:XX:XX:XX:XX
bluetoothctl trust XX:XX:XX:XX:XX:XX
