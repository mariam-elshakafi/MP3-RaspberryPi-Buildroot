#!/bin/sh
#This script is to be used for initializing Bluetooth.


hciattach /dev/ttyAMA0 bcm43xx 115200 noflow
sleep 0.2
modeprobe hci_uart
modprobe btusb
hciconfig hci0 up
sleep 0.2
bluetoothd &
sleep 0.2 
bluealsa &
sleep 0.2

