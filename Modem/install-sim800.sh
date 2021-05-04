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
  echo 'enable_uart=1' >> /boot/config.txt
fi

if grep -q '^dtparam=i2c_arm=on' /boot/config.txt; then
  echo '2 - Seems i2c_arm parameter already set, skip this step.'
else
  echo 'dtparam=i2c_arm=on' >> /boot/config.txt
fi

echo '>>> Install wvdial template for SIM800'
cp overlays/etc/wvdial.conf.tmpl /etc/wvdial.conf.tmpl
cp overlays/etc/wvdial.conf.tmpl /etc/wvdial.conf
chmod 755 /etc/wvdial.conf
cp overlays/etc/ppp/peers/wvdial /etc/ppp/peers/wvdial
