#! /bin/sh

if [ "$1" = "on" ];then
	insmod /lib/modules/sdk/hi_kbasic.ko
	insmod /lib/modules/sdk/hi_kipc.ko
	insmod /lib/modules/sdk/hi_dma.ko
	insmod /lib/modules/sdk/delivery.ko
	insmod /lib/modules/sdk/hi_pts.ko
	insmod /lib/modules/sdk/hi_cnt.ko 
	insmod /lib/modules/sdk/hi_diag_chip.ko
	insmod /lib/modules/sdk/hi_diag_chip_l3.ko
	insmod /lib/modules/sdk/hi_diag_cnt.ko
	insmod /lib/modules/sdk/hi_diag_cap.ko
	insmod /lib/modules/sdk/hi_diag_adapt_cnt.ko
	insmod /lib/modules/sdk/hi_diag_api.ko
	insmod /lib/modules/sdk/hi_khalext.ko
	insmod /lib/modules/sdk/hi_kchipext.ko
	camd&
elif [ "$1" = "off" ];then
	killall -9 camd
	rmmod /lib/modules/sdk/hi_kchipext.ko
	rmmod /lib/modules/sdk/hi_khalext.ko
	rmmod /lib/modules/sdk/hi_diag_api.ko
	rmmod /lib/modules/sdk/hi_diag_adapt_cnt.ko
	rmmod /lib/modules/sdk/hi_diag_cap.ko
	rmmod /lib/modules/sdk/hi_diag_cnt.ko
	rmmod /lib/modules/sdk/hi_diag_chip_l3.ko
	rmmod /lib/modules/sdk/hi_diag_chip.ko
	rmmod /lib/modules/sdk/hi_cnt.ko 
	rmmod /lib/modules/sdk/hi_pts.ko
	rmmod /lib/modules/sdk/delivery.ko
	rmmod /lib/modules/sdk/hi_dma.ko
	rmmod /lib/modules/sdk/hi_kipc.ko
	rmmod /lib/modules/sdk/hi_kbasic.ko
else
	echo "sdkcmd on"
	echo "sdkcmd off"
fi
