# MP3-RaspberryPi-Buildroot
Mp3 player made for raspberry pi 3 using buildroot.

### Features

1. Can be controlled using 4 buttons:
- Start/Stop
- Next
- Previous/Restart
- Shuffle

2. Can be controlled using keyboard commands:
- start
- stop
- next
- prev
- restart
- shuf

3. Can be accessed with ssh through Ethernet (IP: 192.168.5.30), or WiFi (IP: 192.168.1.30).

4. Can be accessed using serial terminal (with TTL module).

5. Voice output can be audio jack or HDMI (Though automatic transition is still under construction :D).

6. You can insert your own songs via a Flash USB.
If your USB is detected, the system will count how many songs available and notify you with text-to-speech.

### Future Work

1. Fully support voice over Bluetooth.
2. Automatic redirection to available audio outputs (Audio jack, HDMI, Bluetooth).

## Tutorial

First, we need to load basic Raspberry Pi 3 configurations through the command:

> make raspberrypi3_64_defconfig

## Menuconfig

> make menuconfig

### Toolchain
We need to use glibc instead of uclibc, as available mp3 applications (madplay, mpg123) need this to start working
![glibc](../assets/Menuconfig/Toolchain/glibc.png?raw=true)

### System Configuration
We need to update our device manager to be able to recognize WiFi and Bluetooth interfaces (You can use mdev, or eudev)
![dev](../assets/Menuconfig/System_Configuration/dev-management.png?raw=true)

Also, since we didn't allow ssh empty password in sshd_config, we'll need to assign a password for root user
![password](../assets/Menuconfig/System_Configuration/password.png?raw=true)

Don't forget to add paths to overlay folder, and your post-build script

**Note:** Don't remove the path for the original Raspberry Pi post-build script, instead just separate paths with a space :D
![postbuild](../assets/Menuconfig/System_Configuration/post-build.png?raw=true)

### Filesystem Image
The size of the image need to be increased for extra packages
![image](../assets/Menuconfig/filesystem.png?raw=true)

### Basic Audio Support

First, we need to enable sound card through /boot/config.txt.
The post-build script adds this line to output/images/rpi-firmware/config.txt

> dtparam=audio=on

In Libraries --> Audio/ Video Support, we enable ALSA support through alsa-lib (All)
![alsa-lib](../assets/Menuconfig/Libraries/alsa-lib.png?raw=true)

In Libraries --> Audio/ Video Support, check port-audio with ALSA support
![port-audio](../assets/Menuconfig/Libraries/port-alsa.png?raw=true)


In Target packages --> Audio/ Video, check alsa-utils (Check them all :D)
![alsa-utils](../assets/Menuconfig/Target_Audio/alsa-utils.png?raw=true)

In Target packages --> Audio/ Video, we need a suitable mp3 player (madplay, mpg123 ..etc)
![madplay](../assets/Menuconfig/Target_Audio/madplay.png?raw=true)
![mpg123](../assets/Menuconfig/Target_Audio/mpg123.png?raw=true)

**Note:** until now, our scripts use madplay. But, mpg123 was included for testing voice over Bluetooth.

### ssh Support

In Target packages --> Networking, check openssh
![openssh](../assets/Menuconfig/Target_Network/openssh.png?raw=true)

### WiFi Support
In Target packages --> Hardware handling --> Firmware, we need to enable WiFi firmware
![wifi](../assets/Menuconfig/Hardware_Firmware/wifi.png?raw=true)

In Target packages --> Networking, check ifupdown (Most probably, this will be already checked)
![ifupdown](../assets/Menuconfig/Target_Network/ifupdown.png?raw=true)

In Target packages --> Networking, check wpa_supplicant (Be sure to check the following options)
![wpa](../assets/Menuconfig/Target_Network/wpa.png?raw=true)

In mp3-overlay folder, you need to configure wpa_supplicant to your network using your ssid and password.
/etc/wpa_supplicant/wpa_supplicant.conf

You can also change IPs through
/etc/network/interfaces

### HDMI Support

HDMI is already supported, but you will face a problem with the audio output if HDMI wasn't connected before booting.
So, our post-build adds these lines to output/images/rpi-firmware/config.txt

> hdmi_safe=1

> hdmi_drive=2


To switch audio output to HDMI, just write this command:

> amixer cset numid=3 2

To switch audio output to audiojack, write this command:

> amixer cset numid=3 1

### Bluetooth Support

The chip used for Bluetooth in Raspberry Pi is by default used for the serial terminal, so we need to change that through /boot/cmdline.txt
Instead of using **ttyAMA0**, we write **ttyS0**; so ttyAMA0 can be used as Bluetooth interface.

The post-build script swaps those two in output/images/rpi-firmware/cmdline.txt

In Target packages --> Hardware handling --> Firmware, we need to enable Bluetooth firmware
![bluetooth](../assets/Menuconfig/Hardware_Firmware/bluetooth.png?raw=true)

In Target packages --> Networking, check bluez-utils 5
![bluez-utils](../assets/Menuconfig/Target_Network/bluez-utils.png?raw=true)

In Target packages --> Networking, check bluez-tools
![bluez-tools](../assets/Menuconfig/Target_Network/bluez-tools.png?raw=true)

Since bluez 5 no more supports bluealsa, we need another audio interface which is PulseAudio
![pulse](../assets/Menuconfig/Target_Audio/pulseaudio.png?raw=true)

### Text-to-Speech

In Target packages --> Audio/ Video, we include espeak
![espeak](../assets/Menuconfig/Target_Audio/espeak.png?raw=true)

## Busybox config

> make busybox-menuconfig

### rfkill
you might have problems with your network interfaces (They can be blocked for some reasons). 
A good diagnostics step is to use rfkill.
This can be found in **Miscellaneous Utilities**.

### shuf
For shuffling, we used $RANDOM in our scripts. 
However, if you prefer shuf command, you can enable this via **Coreutils**.
