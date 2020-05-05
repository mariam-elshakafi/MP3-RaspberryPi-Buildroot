#!/bin/sh
#This script is to be used for initializing Bluetooth.

#Bringing up the Bluetooth interface
hciattach /dev/ttyAMA0 bcm43xx 921600 noflow
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
bluetoothctl pair 7B:6B:39:86:A5:1F
bluetoothctl connect 7B:6B:39:86:A5:1F
bluetoothctl trust 7B:6B:39:86:A5:1F
