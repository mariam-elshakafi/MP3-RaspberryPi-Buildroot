#!/bin/bash

sed -i "s/export PS1='# '/export PS1='MP3_shell> '/" ${TARGET_DIR}/etc/profile

chmod 744 ${TARGET_DIR}/etc/init.d/S40PulseAccessService
chmod 744 ${TARGET_DIR}/etc/init.d/S55MP3Service
chmod 744 ${TARGET_DIR}/etc/init.d/S60AudioDeviceService
chmod 744 ${TARGET_DIR}/etc/init.d/S60MountsService

chmod 755 ${TARGET_DIR}/MP3/audioDeviceManager.sh
chmod 755 ${TARGET_DIR}/MP3/mainDaemon.sh
chmod 755 ${TARGET_DIR}/MP3/mountsCheck.sh
chmod 755 ${TARGET_DIR}/MP3/mp3Start.sh
chmod 755 ${TARGET_DIR}/MP3/areadInputs.sh
chmod 755 ${TARGET_DIR}/MP3/startBluetooth.sh
