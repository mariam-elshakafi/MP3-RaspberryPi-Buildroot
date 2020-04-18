#!/bin/sh

hciattach /dev/ttyAMA0 bcm43xx 115200 noflow
sleep 0.2
hciconfig hci0 up
sleep 0.2
bluetoothd &
sleep 0.2 
bluealsa &
sleep 0.2

