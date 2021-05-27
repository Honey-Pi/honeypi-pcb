[ -z $BASH ] && { exec bash "$0" "$@" || exit; }
#!/bin/bash
# file: install-sim800.sh
#
# This script will install required software for HoneyPi.
# It is recommended to run it in your home directory.
#

# check if sudo is used
if [ "$(id -u)" != 0 ]; then
  echo 'Sorry, you need to run this script with sudo'
  exit 1
fi

if grep -q '^enable_uart=1' /boot/config.txt; then
  echo '1 - Seems enable_uart=1 already set, skip this step.'
else
  echo '1 - Added enable_uart=1'
  echo 'enable_uart=1' >> /boot/config.txt
fi

if grep -q '^dtparam=i2c_arm=on' /boot/config.txt; then
  echo '2 - Seems i2c_arm parameter already set, skip this step.'
else
  echo '2 - Added dtparam=i2c_arm=o'
  echo 'dtparam=i2c_arm=on' >> /boot/config.txt
fi

echo '3 - Added /etc/wvdial.conf file for SIM800L Modem'
cp overlays/etc/wvdial.conf.tmpl /etc/wvdial.conf.tmpl
cp overlays/etc/wvdial.conf.tmpl /etc/wvdial.conf
chmod 755 /etc/wvdial.conf
echo '4 - Added /etc/ppp/peers/wvdial file for SIM800L Modem'
cp overlays/etc/ppp/peers/wvdial /etc/ppp/peers/wvdial
echo 'If you have another provider and your APN is not pinternet.interkom.de you need to change the overlays/etc/wvdial.conf.tmpl file and change the APN there. After changing this file you need to run this installer again. In case your APN is pinternet.interkom.de then eveything is fine and you can run this installer without changing anything. Also you might need to disable the PIN on your sim card first.'
echo '5 - Your turn: Please go to the webinterface, select the modem as your internet mode and reboot your raspberry pi.'
echo '6 - For your info: If you have the modem connected it should show as ttyS0'
ls -la /dev/tty*
