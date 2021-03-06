#!/bin/sh

KillProcess()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -9 $pid
        fi
        echo "Done!"
}

KillProcessNormal()
{
        echo -n "Start kill $1 ...... "
        pid=$(pidof $1)
        if [ ! "$pid" = "" ]; then
                kill -15 $pid
        fi
        echo "Done!"
}

KillProcessFivetimeNormal()
{
        count=0
        while [ $count -lt 5 ]; do
        #echo $count
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -15 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

KillProcessFivetime()
{
        count=0
        while [ $count -lt 5 ]; do
        #echo $count
        pid=$(pidof $1)
        if [ "$pid" != "" ]; then
                kill -9 $pid
                sleep 1
                let count=$count+1
        else
          break
        fi
        done

        if [ $count -eq 5 ]; then
                echo clean $1 fail! > /proc/wap_proc/wap_log
        fi
}

CheckProcess()
{
        echo "================Start check==================="
        # kill vspa's watchdog
        KillProcessFivetime watchproc.sh

        # kill vspa
        KillProcessFivetime vspa_h248
        KillProcessFivetime vspa_sip

        # kill omci
        KillProcessFivetime omci

        # kill oam
        KillProcessFivetime oam

        # kill amp
        #KillProcessFivetime amp

        # kill smp_usb
        KillProcessFivetime smp_usb

        # kill hw_ldsp_user
        KillProcessFivetime hw_ldsp_user

        # kill dnsmasq
        KillProcessFivetime dnsmasq

        # kill dhcpd
        KillProcessFivetime dhcpd

        # kill dhcpc
        KillProcessFivetime dhcpc

        # kill upnpdmain
        KillProcessFivetime upnpdmain

        # kill hostapd
        KillProcessFivetime hostapd

        # kill apm
        KillProcessFivetime apm

        # kill igmp
        KillProcessFivetime igmp

        # kill ethoam
        KillProcessFivetime ethoam

        # kill bbsp
        #KillProcessFivetime bbsp

        # kill cwmp
        KillProcessFivetime cwmp

        # kill web
        KillProcessFivetime web

        # kill procmonitor
        KillProcessFivetimeNormal procmonitor

        echo "================Done check==================="
}

# close the kernel print
echo 0 > /proc/sys/kernel/printk

echo "=========================================="
echo "== Start clean memory for Multi-Upgrade! ="
echo "=========================================="

echo "Current memeory info:"
free

echo "=========================================="
echo "Current status info:"
ps

echo "=========================================="

echo "Start kill process ! "

# kill procmonitor
KillProcessNormal procmonitor

# kill web
KillProcess web

# kill cwmp
KillProcess cwmp

# kill vspa's watchdog
KillProcess watchproc.sh

# kill vspa
KillProcess vspa_h248
KillProcess vspa_sip
KillProcess voice_h248sip
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
#KillProcess bbsp

# kill wifi
KillProcess wifi

# kill usb_mngt
KillProcess usb_mngt


# kill hw_ldsp_xpon_adpt
KillProcess hw_ldsp_xpon_adpt

# kill ldspcli
KillProcess ldspcli

# kill aging
KillProcess aging

# kill ip6tables-restore
KillProcess ip6tables-restore

# kill DcmScantask
KillProcess DcmScantask
# kill ksd5203autoload
KillProcess ksd5203autoload
# kill kdcmdispatchd
KillProcess kdcmdispatchd

# kill RtmpCmdQTask
KillProcess RtmpCmdQTask

# kill RtmpWscTask
KillProcess RtmpWscTask

# kill datacard_thread
KillProcess datacard_thread

# kill clid
KillProcess clid


echo "Kill process done! "

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

# Open the kernel print
while true; do sleep 10; echo 7 > /proc/sys/kernel/printk; break; done &
while true; do sleep 10; CheckProcess; break; done &

# return 0 to system for other application to get the status
return 0