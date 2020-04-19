#!/bin/bash


config_file=output/images/rpi-firmware/config.txt
cmdline_file=output/images/rpi-firmware/cmdline.txt

sed -i "s/export PS1='# '/export PS1='MP3_shell> '/" ${TARGET_DIR}/etc/profile
sed -i "/^pulse-access/ s/$/,root/" ${TARGET_DIR}/etc/group
chmod 744 ${TARGET_DIR}/etc/init.d/S60MP3Service

if [ ! `cat $config_file | grep "dtparam=audio=on"` ]; then 
    echo "" >> $config_file
    echo "#Enable soundcard" >>  $config_file
    echo "dtparam=audio=on" >> $config_file
fi

if [ ! `cat $config_file | grep "hdmi_safe=1"` ]; then 
    echo "" >> $config_file
    echo "#Enable HDMI mode at boot time" >> $config_file
    echo "hdmi_safe=1" >> $config_file
    echo "hdmi_drive=2" >> $config_file
fi

sed -i "s/ttyAMA0/ttyS0/" $cmdline_file
