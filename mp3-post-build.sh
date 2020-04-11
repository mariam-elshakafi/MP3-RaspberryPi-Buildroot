#!/bin/bash


sed -i "s/export PS1='# '/export PS1='MP3_shell> '/" ${TARGET_DIR}/etc/profile
chmod 744 ${TARGET_DIR}/etc/init.d/S60MP3Service

