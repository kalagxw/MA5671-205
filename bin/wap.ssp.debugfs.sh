#!/bin/sh

insmod /lib/modules/hisi_sdk/hi_eth.ko
insmod /lib/modules/hisi_sdk/hi_dp.ko
insmod /lib/modules/hisi_sdk/hi_ioctl_dp.ko
insmod /lib/modules/hisi_sdk/hi_mdio.ko
insmod /lib/modules/hisi_sdk/hi_gpio.ko
insmod /lib/modules/hisi_sdk/hi_gpio_int.ko
insmod /lib/modules/hisi_sdk/hi_i2c.ko
insmod /lib/modules/hisi_sdk/hi_timer.ko
insmod /lib/modules/hisi_sdk/hi_spi.ko
insmod /lib/modules/hisi_sdk/hi_sysctl.ko
insmod /lib/modules/hisi_sdk/hi_uart.ko
insmod /lib/modules/hisi_sdk/hi_dma.ko
insmod /lib/modules/hisi_sdk/hi_hw.ko  
insmod /lib/modules/hisi_sdk/hi_ext_int.ko  
insmod /lib/modules/hisi_sdk/hi_ioctl_sysctl.ko

# activate ethernet drivers
ifconfig lo up
ifconfig eth0 hw ether 00:00:00:00:00:01 192.168.100.1 up 
ifconfig eth0 mtu 1500

mkdir /var/tmp
mkdir /var/run

echo "Loading the EchoLife WAP modules: LDSP"

# hw_module_common.ko hw_module_hlp.ko are needed by all of ko
insmod /lib/modules/wap/hw_module_common.ko
insmod /lib/modules/wap/hw_module_hlp.ko

insmod /lib/modules/wap/hw_module_phy.ko
insmod /lib/modules/wap/hw_module_msgque.ko
insmod /lib/modules/wap/hw_soc_sd5113.ko
insmod /lib/modules/wap/hw_module_gpio.ko
insmod /lib/modules/wap/hw_module_highway.ko
insmod /lib/modules/wap/hw_module_i2c.ko
insmod /lib/modules/wap/hw_module_mdio.ko

if [ -e /var/ar8316e.txt ]
then
  insmod /lib/modules/wap/hw_ker_ar8316e_lsw.ko
  rm -rf /var/ar8316.txt
else
  insmod /lib/modules/wap/hw_ker_ar8316_lsw.ko
  rm -rf /var/ar8316e.txt
fi

insmod /lib/modules/wap/hw_module_spi.ko
insmod /lib/modules/wap/hw_module_uart.ko
insmod /lib/modules/wap/hw_module_battery.ko
insmod /lib/modules/wap/hw_module_ploam.ko
insmod /lib/modules/wap/hw_module_gmac.ko
insmod /lib/modules/wap/hw_module_key.ko
insmod /lib/modules/wap/hw_module_lsw.ko
insmod /lib/modules/wap/hw_module_led.ko
insmod /lib/modules/wap/hw_module_optic.ko
insmod /lib/modules/wap/hw_module_rf.ko
insmod /lib/modules/wap/hw_ker_codec.ko
insmod /lib/modules/wap/hw_module_dev.ko

# This module needed by DSP
insmod /lib/modules/wap/hw_module_topo.ko
insmod /lib/modules/wap/hw_module_topo_pdt.ko

insmod /bin/hw_module_bbsp_wifi.ko
insmod /lib/modules/wap/hw_module_ifmdev.ko

# creat bridge and bind the eth0
brctl addbr br0
ifconfig eth0 0.0.0.0 up
brctl addif br0 eth0
ifconfig br0 192.168.100.1 up

#add by zhaochao for ldsp_user
iLoop=0
echo -n "Start ldsp_user..."
if [ -e /bin/hw_ldsp_cfg ]
then
  hw_ldsp_cfg &
  while [ $iLoop -lt 5 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
  do
    echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 1
  done
  
  if [ -e /var/hw_ldsp_tmp.txt ]
  then 
      rm -rf /var/hw_ldsp_tmp.txt
  fi
fi

if [ -e /bin/hw_ldsp_user ]
then
    hw_ldsp_user &
fi

# set hybrid reg
mw 0x42780004 0x1f

# cancle QOS car
sndhlp 0 0x2000151c 28 12 0 8000 12000
# multicast
sndhlp 0 0x20001500 0 160 25 0x4  0 0x101001 0 0  0x0 0x005e0001 0xffff0000 0x000000ff 0  0x0 0 0 0 0  0x0 0 0 0 0 0x2 0 0 0 0 0x0 0 0 0 0 0x0 0 0 0 0 0x0 0x8 0x100001 0

# 外挂所有端口加入Vlan 1888
sndhlp 0 0x20001216 22 8 1888 0x200002
sndhlp 0 0x20001216 22 8 1888 0x200003
sndhlp 0 0x20001216 22 8 1888 0x200004
sndhlp 0 0x20001216 22 8 1888 0x200001
sndhlp 0 0x20001216 22 8 1888 0x200000

# 外挂所有端口pvid设置为1888
sndhlp 0 0x20001206 6 16 0x200002 0 1888  0
sndhlp 0 0x20001206 6 16 0x200003 0 1888  0
sndhlp 0 0x20001206 6 16 0x200004 0 1888  0
sndhlp 0 0x20001206 6 16 0x200001 0 1888  0
sndhlp 0 0x20001206 6 16 0x200000 0 1888  0

# cpu加入vlan 1888
sndhlp 0 0x20001216 22 8 1888 0x101001

# 把cpu加入到l2mac静态表
sndhlp 0 0x2000140a 10 20 0x101001 1888 0 0x0 0x0100

# 设置CPU native Vlan
mw 0x4360003C 0x760 

# 设置vlan 1888 hybrid
mw 0x42781d80 0x1

#5113级联口加入到vlan 1888
sndhlp 0 0x20001216 22 8 1888 0x100001

#remove hw_module_ifmdev
rmmod hw_module_ifmdev

ifconfig ath0 up

IP=`ip addr show br0 | grep "inet" | cut -d "/" -f 1 | cut -c 10-`
busybox arping -A -c 1 -i br0 $IP

