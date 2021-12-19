[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: install-monitor.sh
#
# This script will install required software for HoneyPi.
# It is recommended to run it in your home directory.
#

# main source: https://die-antwort.eu/techblog/2017-12-setup-raspberry-pi-for-kiosk-mode/

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
 echo 'Sorry, you need to run this script with sudo'
 exit 1
fi

echo '1 - initial setup, update all preinstalled packages...'
apt-get update
apt-get upgrade -y

echo '2 - enable pi autologin...'
cp overlays/autologin.conf /etc/systemd/system/getty@tty1.service.d/autologin.conf

echo '3 - The bare minimum we need are X server and window manager...'
apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox -y

echo '4 - We’ll use Chromium because it provides a nice kiosk mode...'
apt-get install --no-install-recommends chromium-browser -y

if grep -q '^hdmi_group=1' /boot/config.txt; then
 echo '5 - Seems hdmi_group=1 already set, skip this step.'
else
 echo '5 - Added hdmi_group=1'
 echo 'hdmi_group=1' >> /boot/config.txt
fi

if grep -q '^hdmi_mode=4' /boot/config.txt; then
 echo '6 - Seems hdmi_mode=4 already set, skip this step.'
else
 echo '6 - Added hdmi_mode=4'
 echo 'hdmi_mode=4' >> /boot/config.txt
fi

echo '7 - Disabled hdmi_safe=1'
sed -i '/hdmi_safe=1/c\#nohdmi_safe=1' /boot/config.txt;

echo '8 - Added chrome to autostart'
cp overlays/autostart /etc/xdg/openbox/autostart

echo '9 - You can test it by running "sudo startx /etc/xdg/openbox/autostart"'
echo '9 - Finished. Please manually reboot. You might need to want to add "sudo startx /etc/xdg/openbox/autostart" to your autostart'
