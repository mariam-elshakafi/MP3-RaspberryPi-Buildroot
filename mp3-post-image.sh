#!/bin/sh

config_file=${BINARIES_DIR}/rpi-firmware/config.txt
cmdline_file=${BINARIES_DIR}/rpi-firmware/cmdline.txt

if [ ! `cat $config_file | grep "dtparam=audio=on"` ]; then 
    echo "" >> $config_file
    echo "#Enable soundcard" >>  $config_file
    echo "dtparam=audio=on" >> $config_file
fi

if [ ! `cat $config_file | grep "hdmi_safe=1"` ]; then 
    echo "" >> $config_file
    echo "#Fix HDMI audio related problems" >> $config_file
    echo "hdmi_drive=2" >> $config_file
fi


if [ ! `cat $config_file | grep "uart_enable=1"` ]; then 
    echo "" >> $config_file
    echo "#Enable Serial at boot time" >> $config_file
    echo "uart_enable=1" >> $config_file
fi

sed -i "s/ttyAMA0/ttyS0/" $cmdline_file
