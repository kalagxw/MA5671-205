#!/bin/sh
# ��������ҵ����̣���ϵͳ��ʼ��Ϊ��ʼ״̬��ֻ����KO

# killall dhcpc
killall -23 dhcpc
echo "Dhcp4 Release!"

#killall dhcp6c
killall -15 dhcp6c
echo "Dhcp6 Release!"

#killall pppd
killall -15 pppd
echo "pppd Terminal!"

sleep 0.5
