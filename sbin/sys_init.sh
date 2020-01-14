#!/bin/sh
# 清理所有业务进程，将系统初始化为开始状态，只保留KO

KillProcess()
{	
	echo -n "Start kill $1 ...... "
	pid=$(pidof $1)
	if [ ! "$pid" = "" ]; then
		kill -9 $pid
	fi
	echo "Done!"
}

CleanIPCs()
{
	echo "Start clean IPC info ..."

	echo -n "Clean sem ... "
	cat /proc/sysvipc/sem | cut -c12-22 | while read m_id; do ipcrm -s $m_id; done
	echo "Done!"

	echo -n "Clean msg ... "
	cat /proc/sysvipc/msg | cut -c12-22 | while read m_id; do ipcrm -q $m_id; done
	echo "Done!"
	
	echo -n "Clean shm ... "	
	cat /proc/sysvipc/shm | cut -c12-22 | while read m_id; do ipcrm -m $m_id; done	
	echo "Done!"
	
}

# close the kernel print
echo 0 > /proc/sys/kernel/printk

echo "=========================================="
echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps

echo "=========================================="

echo "Start kill process ! "

# kill procmonitor
KillProcess procmonitor

# kill web
KillProcess web

# kill cwmp
KillProcess cwmp

# kill vspa's watchdog
KillProcess watchproc.sh

# kill vspa
KillProcess vspa_h248
KillProcess vspa_sip

# kill omci
KillProcess omci

# kill omci
KillProcess oam

# kill amp
KillProcess amp

# kill smp_usb
KillProcess smp_usb

# kill hw_ldsp_user
KillProcess hw_ldsp_user

# kill dnsmasq
KillProcess dnsmasq

# kill dhcpd
KillProcess dhcpd

# kill apm
KillProcess apm

# kill igmp
KillProcess igmp

# kill ethoam
KillProcess ethoam

# kill bbsp
KillProcess bbsp

# kill ssmp
KillProcess ssmp

# kill mu
KillProcess mu

# kill clid
KillProcess clid

sleep 2

echo "Kill process done! "

# clean IPCs
CleanIPCs

# Drop page cache
echo -n "Start drop page cache ...... "
echo 3 > /proc/sys/vm/drop_caches
echo "Done!"

echo "=========================================="
echo "== End clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps

echo "=========================================="
cat /proc/sysvipc/shm

echo "=========================================="
cat /proc/sysvipc/msg

echo "=========================================="
cat /proc/sysvipc/sem

# Open the kernel print
while true; do sleep 10; echo 7 > /proc/sys/kernel/printk; break; done &

# return 0 to system for other application to get the status
return 0

