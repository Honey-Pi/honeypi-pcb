sudo rtcctl init

sudo rtcctl on alarm1
sudo rtcctl on alarm2

printf -v Uhrzeit '%(%Y-%m-%d %H:%M:%S)T\n' -1

# Setting the wakeup time:
WakeUpTime=$(date -d +10minutes +'%m/%d/%Y %H:%M:%S')

echo "WakeUpTime>(Wiedereinschaltzeit)" $WakeUpTime

sudo rtcctl set alarm1 $WakeUpTime



echo "Good bye"
sudo rtcctl clear alarm1 #That is the signal to switch of!!!
sudo rtcctl show


# alarm2 is not necessary, but available. 
# sudo rtcctl set alarm2 $WakeUpTime2