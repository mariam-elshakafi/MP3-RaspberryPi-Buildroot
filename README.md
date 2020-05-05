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

> make raspberrypi3_defconfig

As we're using rpi-userland for HDMI detection, make sure you start with 32 base (The package is not available for 64 base).

## Menuconfig

> make menuconfig

### Toolchain
We need to use **glibc** instead of **uclibc**, as available mp3 applications (madplay, mpg123, sox) need this to start working
![glibc](../assets/Menuconfig/Toolchain/glibc.png?raw=true)

### System Configuration
We need to update our device manager to be able to recognize WiFi and Bluetooth interfaces (You can use mdev, or eudev)
![dev](../assets/Menuconfig/System_Configuration/dev-management.png?raw=true)

Also, since we didn't allow ssh empty password in sshd_config, we'll need to assign a password for root user
![password](../assets/Menuconfig/System_Configuration/password.png?raw=true)

Don't forget to add paths to overlay folder, post-build script, and post-image script.

**Notes:** 

1. Don't remove the path for the original Raspberry Pi post-build script or post-image, instead just separate paths with a space :D
![postbuild](../assets/Menuconfig/System_Configuration/post-build.png?raw=true)

2. The rpi default post-image generates the sdcard.img. So, you have to execute the mp3-post-image first.\
This is done by providing the paths to post-image scripts in order (mp3 first, default second) as found in our defconfig.

3. **IMPORTANT**: the default post-image for 32 base add miniuart overlay in config.txt because of the input argument passed to the post-image, which occupies the chip used for Bluetooth (terminal: ttyAMA0) and uses it for serial. So, you have to remove the extra argument passed to post-image!

### Filesystem Image
The size of the image need to be increased for extra packages
![image](../assets/Menuconfig/filesystem.png?raw=true)

### Basic Audio Support

First, we need to enable sound card through /boot/config.txt.
The post-image script adds this line to output/images/rpi-firmware/config.txt

> dtparam=audio=on

In Libraries --> Audio/ Sound Support, we enable ALSA support through **alsa-lib** (All)

In Libraries --> Audio/ Sound Support, check **port-audio** with ALSA support

In Target packages --> Audio/ Video, check **alsa-utils** (Check them all :D)

In Target packages --> Audio/ Video, we need a suitable mp3 player (madplay, mpg123 ..etc).\
For Bluetooth problems, **sox** was our best option. It can be used to play music using **play** command.

### ssh Support

In Target packages --> Networking, check **openssh**

Also, The post-image script adds this line to output/images/rpi-firmware/config.txt

> enable_uart=1

for enabling UART on the serial terminal (ttyS0).

### WiFi Support

In Target packages --> Hardware handling --> Firmware, we need to enable WiFi firmware: **rpi-wifi-firmware**

In Target packages --> Networking, check **ifupdown** (Most probably, this will be already checked)

In Target packages --> Networking, check **wpa_supplicant** (Be sure to check the following options):

- Enable nl80211 support
- Enable autoscan
- Install wpa_passphrase binary

In mp3-overlay folder, you need to configure wpa_supplicant to your network using your ssid and password.
/etc/wpa_supplicant/wpa_supplicant.conf

You can also change IPs through: /etc/network/interfaces

### HDMI Support

HDMI is already supported, but you will face a problem with the audio output if HDMI wasn't connected before booting.
So, our post-image adds these lines to output/images/rpi-firmware/config.txt

> hdmi_drive=2


To switch audio output to HDMI, just write this command:

> amixer cset numid=3 2

To switch audio output to audiojack, write this command:

> amixer cset numid=3 1

This is done in /MP3/audioDeviceManager.sh

### Bluetooth Support

The chip used for Bluetooth in Raspberry Pi is by default used for the serial terminal, so we need to change that through /boot/cmdline.txt
Instead of using **ttyAMA0**, we write **ttyS0**; so ttyAMA0 can be used as Bluetooth interface.

The post-build script swaps those two in output/images/rpi-firmware/cmdline.txt

In Target packages --> Hardware handling --> Firmware, we need to enable Bluetooth/WiFi chip firmware: **b43-firmware**

In Target packages --> Networking, check **bluez-utils 5**

In Target packages --> Networking, check **bluez-tools**

Since alsa doesn't support bluez 5, we have one of 3 options:

- **ALSA + Bluez (<=4):** 
  However, support for bcm43xx was introduced in Bluez 5. So, it's hard to bring up the bluetooth interface using older Bluez versions.
  We tried replacing hciattach binary with that of Bluez 5. The interface was up, connected to headset, but no sound output.

- **ALSA + Bluez 5 + bluealsa:**
  This should be a valid option. However, there's a problem with alsa not recognizing bluealsa as a pcm, although the bluealsa configurations exist.

- **ALSA + Bluez 5 + PulseAudio:**
  This has been the most successful option. Although you'll need to install jackd server to manage access to sound card. So, ALSA wouldn't bring PulseAudio down.

Needed packages for option 3:

In Target packages --> Audio/ Video, include **pulseaudio** (start as system daemon)

*Our mp3-overlay changes some pulseaudio options to work on Bluetooth properly.*

In Target packages --> Audio/ Video, include **jack1**

In Target packages --> Libraries --> Audio/ Sound, include **sbc**

### Text-to-Speech

In Target packages --> Audio/ Video, include **espeak**

## Busybox config

> make busybox-menuconfig

### rfkill
you might have problems with your network interfaces (They can be blocked for some reasons). 
A good diagnostics step is to use rfkill.
This can be found in **Miscellaneous Utilities**.


### shuf
For shuffling, we used $RANDOM in our scripts. 
However, if you prefer shuf command, you can enable this via **Coreutils**.



## References

**WiFi**

- https://blog.crysys.hu/2018/06/enabling-wifi-and-converting-the-raspberry-pi-into-a-wifi-ap/


**Bluetooth**

General:

- https://tewarid.github.io/2014/10/29/bluetooth-on-raspberry-pi-with-buildroot.html
- https://www.linux-magazine.com/Issues/2017/197/Command-Line-bluetoothctl

Bluez 3 problems:

- https://www.raspberrypi.org/forums/viewtopic.php?t=147919&start=25

PulseAudio problems:

- https://oldwiki.archive.openwrt.org/doc/howto/bluetooth.audio
- https://github.com/Katee/quietnet/issues/18

Bluealsa problems:

- https://github.com/Arkq/bluez-alsa
- https://forum.armbian.com/topic/6480-bluealsa-bluetooth-audio-using-alsa-not-pulseaudio/
- https://askubuntu.com/questions/713145/how-do-i-connect-bluez-alsa-to-an-audio-device
- https://www.raspberrypi.org/forums/viewtopic.php?t=107144

RPI defconfig for base 32 problems:

- https://stackoverflow.com/questions/44554255/bcm43xx-init-initialization-timed-out-with-buildroot-raspberry-pi-3-hciattach

**HDMI**

- https://www.raspberrypi.org/documentation/configuration/audio-config.md
