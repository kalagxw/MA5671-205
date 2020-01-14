#!/bin/sh

echo "Ram start enter!"

# test for equipmode

var_proc_name="ssmp bbsp amp"
start $var_proc_name&

ssmp &

if [ -e /mnt/jffs2/Equip.sh ]
then

bbsp equip &
amp equip &

else

bbsp &
amp &

fi

while true; do
    sleep 1
    if [ -f /var/ssmploaddata ] ; then
		rmmod  hw_module_dsp
		rmmod  hw_module_dsp_sdk 
		rmmod  hw_module_dopra
		rmmod  hw_module_battery
		rmmod  hw_module_rf
		procmonitor ssmp &
		sleep 1
        mu& break; 
    fi
done &

exit
