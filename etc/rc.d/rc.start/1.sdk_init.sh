#!/bin/sh
#添加lib的环境变量

[ -n $LD_LIBRARY_PATH ] && export LD_LIBRARY_PATH=/lib:/lib/omci_module:/lib/oam_module:/usr/osgi/lib:/usr/osgi/lib/arm:/usr/osgi/lib/arm/jli:/usr/osgi/lib/arm/minimal;


#加载故障自愈的ko
insmod /lib/modules/wap/hw_ssp_sys_res.ko

# 持裁剪jffs2文件系统，完成之后恢复log
#echo "Mount Jffs2 in 1.sdk_init..."

mount -t ubifs -o sync /dev/ubi0_13 /mnt/jffs2/
echo "Mount nor jffs2 in 1.sdk_init..."
var_index=$(cat /proc/mtd | grep file_system | cut -d ":" -f 1 | cut -c 4-)
mount -t jffs2 /dev/mtdblock$var_index /mnt/jffs2

Reloadlog

[ -f /mnt/jffs2/stop ] && exit

[ -f /lib/modules/linux/kernel/net/ipv6/ipv6.ko ] && insmod /lib/modules/linux/kernel/net/ipv6/ipv6.ko
#[ -f /lib/modules/linux/kernel/net/ipv4/tunnel4.ko ] && insmod /lib/modules/linux/kernel/net/ipv4/tunnel4.ko
#[ -f /lib/modules/linux/kernel/net/ipv6/sit.ko ] && insmod /lib/modules/linux/kernel/net/ipv6/sit.ko

HW_LANMAC_TEMP="/var/hw_lanmac_temp"

HW_BOARD_LANMAC="00:00:00:00:00:02"

echo -n "Rootfs time stamp:"
cat /etc/timestamp

echo -n "SVN label(ont):"
cat /etc/wap/ont_svn_info.txt

#echo 100 > /proc/sys/vm/pagecache_ratio
#echo 3 > /proc/sys/vm/drop_caches
echo 64 > /proc/sys/kernel/msgmni
echo 2048 > /proc/sys/net/ipv4/route/max_size
echo 8192 > /proc/sys/vm/min_free_kbytes 

#避免eth0发RS
[ -f /proc/sys/net/ipv6/conf/default/forwarding ] && echo 1 > /proc/sys/net/ipv6/conf/default/forwarding

# Close/Open(0/8) the printk for debug
echo 8 > /proc/sys/kernel/printk

# 配置网络参数
echo 128 > /proc/sys/net/core/dev_weight
echo 640 > /proc/sys/net/core/netdev_budget
echo 1300 > /proc/sys/net/core/netdev_max_backlog
echo 163840 > /proc/sys/net/core/rmem_default
echo 163840 > /proc/sys/net/core/rmem_max
echo 163840 > /proc/sys/net/core/wmem_default
echo 163840 > /proc/sys/net/core/wmem_max
echo 5490 7320 10980 > /proc/sys/net/ipv4/tcp_mem
echo 5490 7320 10980 > /proc/sys/net/ipv4/udp_mem
echo 4096 87380 234240 > /proc/sys/net/ipv4/tcp_rmem
echo 4096 16384 234240 > /proc/sys/net/ipv4/tcp_wmem

echo !reload > /proc/wap_proc/voice_log

[ -f /mnt/jffs2/Equip.sh ] && /bin/Equip.sh && exit

var_xpon_mode=`cat /mnt/jffs2/hw_boardinfo | grep "0x00000001" | cut -c38-38`
echo "xpon_mode:${var_xpon_mode}"

echo ${var_xpon_mode}>>/var/var_xpon_mode

echo "User init start......"

# load hisi modules
if [ -f /mnt/jffs2/TranStar/hi_sysctl.ko ]; then
	  cd /mnt/jffs2/TranStar/
	  echo "Loading the Temp HISI SD511X modules: "
else
	  cd /lib/modules/hisi_sdk
	  echo "Loading the HISI SD511X modules: "
fi
		
    insmod hi_sysctl.ko
    insmod hi_spi.ko	
    insmod hi_pie.ko tx_chk=0
   
tempChipType1=`md 0x10100800 1`
tempChipType=`echo $tempChipType1 | sed 's/.*:: //' | sed 's/[0-9][0-9]00//' | cut -b 1-4`

if [ $tempChipType -eq 5115 ]; then
    insmod hi_gpio_5115.ko
else
    insmod hi_gpio.ko
fi    
    insmod hi_i2c.ko
    insmod hi_timer.ko
    insmod hi_serdes.ko	

    insmod hi_hw.ko
    insmod hi_uart.ko
    insmod hi_dma.ko
if [ -e /mnt/jffs2/PhyPatch ]; then
    echo "phy patch path is /mnt/jffs2/PhyPatch/ "
    if [ $tempChipType -eq 5115 ]; then
        insmod hi_bridge_5115.ko	pPhyPatchPath="/mnt/jffs2/PhyPatch/"
    else    
        insmod hi_bridge.ko pPhyPatchPath="/mnt/jffs2/PhyPatch/"
    fi
else
    if [ $tempChipType -eq 5115 ]; then
        insmod hi_bridge_5115.ko	
    else    
        insmod hi_bridge.ko
    fi
fi
	insmod hi_ponlp.ko
	
if [ ${var_xpon_mode} == "5" ]; then	
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
elif [ ${var_xpon_mode} == "6" ]; then
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
elif [ ${var_xpon_mode} == "7" ]; then
	insmod hi_xgpon.ko
	insmod hi_xepon.ko
else
    insmod hi_gpon.ko
    insmod hi_epon.ko
fi    

if [ $tempChipType -eq 5115 ]; then
    insmod hi_l3_5115.ko
else    	
    insmod hi_l3.ko
fi    
    insmod hi_oam.ko	     
    insmod hi_sci.ko
    insmod hi_mdio.ko	
    #insmod hi_adp_cnt.ko

cd /

# set lanmac 
getlanmac $HW_LANMAC_TEMP
if [ 0  -eq  $? ]; then
    read HW_BOARD_LANMAC < $HW_LANMAC_TEMP
    echo "ifconfig eth0 hw ether $HW_BOARD_LANMAC"
    ifconfig eth0 hw ether $HW_BOARD_LANMAC
fi

# delete temp lanmac file
if [ -f $HW_LANMAC_TEMP ]; then
    rm -f $HW_LANMAC_TEMP
fi

# activate ethernet drivers

ifconfig eth0 192.168.100.1 up
ifconfig eth0 mtu 1500

mkdir /var/tmp

if [ -f /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko ]; then
	insmod /lib/modules/linux/extra/arch/arm/mach-hisi/pcie.ko
	insmod /lib/modules/wap/hw_module_acp.ko
fi

echo "Loading the EchoLife WAP modules: LDSP"

# hw_module_common.ko hw_module_hlp.ko are needed by all of ko

insmod /lib/modules/wap/hw_module_common.ko

insmod /lib/modules/wap/hw_module_gpio.ko
insmod /lib/modules/wap/hw_module_i2c.ko
insmod /lib/modules/wap/hw_module_uart.ko
insmod /lib/modules/wap/hw_module_battery.ko
insmod /lib/modules/wap/hw_module_optic.ko
insmod /lib/modules/wap/hw_module_key.ko
insmod /lib/modules/wap/hw_module_led.ko
insmod /lib/modules/wap/hw_module_rf.ko
insmod /lib/modules/wap/hw_module_sim.ko
insmod /lib/modules/wap/hw_module_dev.ko

#dm产品侧ko,需在hw_module_dev.ko加载后加载
insmod /lib/modules/wap/hw_dm_pdt.ko
insmod /lib/modules/wap/hw_module_feature.ko
insmod /lib/modules/wap/hw_module_mpcp.ko

if [ ${var_xpon_mode} == "5" ]; then	
	 insmod /lib/modules/wap/hw_module_xgploam.ko
else
   insmod /lib/modules/wap/hw_module_ploam.ko
fi

   insmod /lib/modules/wap/hw_module_phy.ko 
if [ -e /var/bcm84846.txt ]; then 
	 insmod /lib/modules/wap/hw_ker_phy_bcm84846.ko
elif [ -e /var/bcm50612e.txt ]; then 
	 insmod /lib/modules/wap/hw_ker_phy_bcm50612e.ko
fi

insmod /lib/modules/wap/hw_module_amp.ko
insmod /lib/modules/wap/hw_module_gmac.ko
insmod /lib/modules/wap/hw_module_emac.ko
insmod /lib/modules/wap/hw_module_wifi.ko

#判断/mnt/jffs2/customize_xml.tar.gz文件是否存在，存在解压
if [ -e /mnt/jffs2/customize_xml.tar.gz ]
then
    #解析customize_relation.cfg
    tar -xzf /mnt/jffs2/customize_xml.tar.gz -C /mnt/jffs2/ customize_xml/customize_relation.cfg  
fi


#产品侧DM加载之后就可以通过/proc/wap_proc/chip_attr文件获取芯片类型
#再根据芯片类型给kbox分配512k高端内存(只是网关产品才添加)
#var_soc_type_kbox_temp=5115H;var_soc_type_kbox=5115
var_soc_attr_kbox=`GetChipDes`
var_soc_type_kbox_temp=`echo $var_soc_attr_kbox | sed 's/.*\"SD//' | sed 's/V[0-9]*\"//' | tr -d '[\015]'`
var_soc_type_kbox=$(echo $var_soc_type_kbox_temp | cut -b 1-4)
if [ $var_soc_type_kbox -eq 5113 ] ; then
	echo "0x9337F000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5115 ] ; then
	echo "0x80880000 512K" > /proc/kbox/mem
elif [ $var_soc_type_kbox -eq 5116 ] ; then
	if [ '$var_soc_type_kbox_temp' == '5116T' ] || [ '$var_soc_type_kbox_temp' == '5116H' ] ; then
		echo "0x80680000 512K" > /proc/kbox/mem
	elif [ '$var_soc_type_kbox_temp' == '5116L' ] ; then
		echo "0x80480000 512K" > /proc/kbox/mem
	elif [ '$var_soc_type_kbox_temp' == '5116S' ] ; then
		echo "0x80080000 512K" > /proc/kbox/mem
	else
		echo "(!5116T/H/L/S)can not configure the kbox!!!"
	fi
elif [ $var_soc_type_kbox -eq 5118 ] ; then
	echo "0x82080000 512K" > /proc/kbox/mem
else
	echo "(!5113&&!5115&&!5116)can not configure the kbox!!!"
fi

var_kbox_config=`cat /proc/kbox/mem`
echo "kbox config(Addr---Size)="$var_kbox_config

#打印进程快照，必须在kbox配置之后
insmod  /lib/modules/3.10.53-HULK2/mts/rtos_snapshot.ko log_size=104

#通过特性开关来启动cwmp进程
resume_enble=`GetFeature HW_SSMP_FEATURE_TR069`
echo $resume_enble > /var/resume_enble_cwmp

. /usr/bin/init_topo_info.sh

echo "pots_num="$pots_num
echo " usb_num="$usb_num
echo "hw_route="$hw_route
echo "   l3_ex="$l3_ex
echo "    ipv6="$ipv6
rm /var/topo.sh

#mem_totalsize=`cat proc/meminfo  | grep MemTotal | awk '{print $2}'`
mem_totalsize=`cat /proc/meminfo | grep MemTotal | cut -c11-22`
echo "Read MemInfo Des:"$mem_totalsize



# pots ko
if [ $pots_num -ne 0 ]
then 
    insmod /lib/modules/wap/hw_module_highway.ko
    insmod /lib/modules/wap/hw_module_spi.ko
    insmod /lib/modules/wap/hw_module_codec.ko
    if [ $pots_num -eq 1 ]
    then
         if [ -e /var/si32176.txt ]
         then
             insmod /lib/modules/wap/hw_ker_codec_si32176.ko
	 elif [ -e /var/pef3201.txt ]
	 then
	     insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
	 elif [ -e /var/le964x.txt ]
	 then
	     insmod /lib/modules/wap/hw_ker_codec_le964x.ko    
	 else
             insmod /lib/modules/wap/hw_ker_codec_ve8910.ko
	     fi
    else
        if [ -e /var/le964x.txt ]
        then
             insmod /lib/modules/wap/hw_ker_codec_le964x.ko
        else     
             #insmod /lib/modules/wap/hw_ker_codec_pef3201.ko
             insmod /lib/modules/wap/hw_ker_codec_le88601.ko
        fi
    fi
fi

#if file is existed ,don't excute
if [ $usb_num -ne 0 ]
then
    cd /lib/modules/linux/
    if [ -f ./extra/drivers/usb/storage/usb-storage.ko ]; then
	 #  insmod ./kernel/fs/nls/nls_base.ko
	    insmod ./kernel/fs/nls/nls_ascii.ko
	    insmod ./kernel/fs/nls/nls_cp437.ko
	    insmod ./kernel/fs/nls/nls_utf8.ko
	    insmod ./kernel/fs/nls/nls_cp936.ko
	    insmod ./kernel/fs/fat/fat.ko
	    insmod ./kernel/fs/fat/vfat.ko
	    insmod ./kernel/fs/fuse/fuse.ko
	    insmod ./kernel/drivers/scsi/scsi_mod.ko
	    insmod ./kernel/drivers/scsi/scsi_wait_scan.ko
		
	    insmod ./extra/drivers/scsi/sd_mod.ko
		
		insmod ./extra/drivers/usb/usb-common.ko
	    insmod ./extra/drivers/usb/core/usbcore.ko
	    insmod ./extra/drivers/usb/host/hiusb-sd511x.ko
	    insmod ./extra/drivers/usb/host/ehci-hcd.ko
	    insmod ./extra/drivers/usb/host/ehci-pci.ko
	    insmod ./extra/drivers/usb/host/ohci-hcd.ko
	    insmod ./extra/drivers/usb/host/xhci-hcd.ko    
	    insmod ./extra/drivers/usb/storage/usb-storage.ko
	    insmod ./extra/drivers/usb/class/usblp.ko
	    insmod ./extra/drivers/usb/class/cdc-acm.ko
		
		insmod ./extra/drivers/usb/serial/usbserial.ko
        insmod ./extra/drivers/usb/serial/usb_wwan.ko
	    insmod ./extra/drivers/usb/serial/option.ko
	    insmod ./extra/drivers/net/usb/hw_cdc_driver.ko
    fi
    cd /
    
    insmod /lib/modules/wap/hw_module_usb.ko
	  insmod /lib/modules/wap/hw_module_datacard.ko
	  insmod /lib/modules/wap/hw_module_datacard_chip.ko
    insmod /lib/modules/wap/smp_usb.ko
fi

# AMP_KO
insmod /lib/modules/wap/hw_amp.ko
#


insmod /lib/modules/wap/hw_smp_dcom.ko
insmod /lib/modules/wap/hw_module_dcom.ko
insmod /lib/modules/wap/hw_module_dcm.ko
insmod /lib/modules/wap/hw_module_autoload.ko


# BBSP_l2_basic
echo "Loading BBSP L2 modules: "
insmod /lib/modules/linux/kernel/drivers/net/slip/slhc.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/ppp_generic.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppox.ko
insmod /lib/modules/linux/kernel/drivers/net/ppp/pppoe.ko

insmod /lib/modules/wap/commondata.ko
insmod /lib/modules/wap/sfwd.ko
insmod /lib/modules/wap/l2ffwd.ko
insmod /lib/modules/wap/hw_bbsp_lswadp.ko
insmod /lib/modules/wap/hw_ptp.ko
insmod /lib/modules/wap/l2base.ko
insmod /lib/modules/wap/acl.ko
insmod /lib/modules/wap/cpu.ko
insmod /lib/modules/wap/bbsp_l2_adpt.ko
insmod /lib/modules/wap/qos_adpt.ko
# BBSP_l2_basic end

# BBSP_l2_extended
echo "Loading BBSP L2_extended modules: "
insmod /lib/modules/wap/l2ext.ko

# BBSP_l2_extended end

# BBSP_l3_basic
echo "Loading BBSP L3_basic modules: "
#insmod /lib/modules/linux/kernel/net/netfilter/nf_conntrack.ko
#insmod /lib/modules/linux/kernel/net/ipv4/netfilter/nf_defrag_ipv4.ko
#insmod /lib/modules/linux/kernel/net/ipv4/netfilter/nf_conntrack_ipv4.ko
#insmod /lib/modules/linux/kernel/net/ipv4/netfilter/nf_nat.ko
#insmod /lib/modules/linux/kernel/net/ipv4/netfilter/iptable_nat.ko
insmod /lib/modules/wap/hw_ssp_gpl_ext.ko

#if [ $mem_totalsize -ge 65537 ]
#then
#    echo 8000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog
#else
#    echo 1500 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog
#fi

#echo 16000 > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog
cat /proc/wap_proc/spec | grep -w BBSP_SPEC_FWD_SESSIONNUM | while read spec_name spec_type spec_len spec_value ;do
   if [ $spec_name = "BBSP_SPEC_FWD_SESSIONNUM" ];then
        echo $spec_value > /proc/sys/net/nf_conntrack_max 2>>/var/xcmdlog
   fi
done
echo 1 > proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal 2>>/var/xcmdlog
#add for rtos, to enable connection tracking flow accounting for new kernel
echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct

iptables-restore -n < /etc/wap/sec_init

insmod /lib/modules/wap/hw_module_trigger.ko
insmod /lib/modules/wap/l3base.ko

#add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
#enable ip forward
echo 1 > /proc/sys/net/ipv4/ip_forward
#disable rp filter
echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
#end of add by zengwei for ip_forward and rp_filter nf_conntrack_tcp_be_liberal
# BBSP_l3_basic end

#  load DSP modules
if [ $pots_num -ne 0 ]
then    
    echo "Loading DSP temporary modules: "
    insmod /lib/modules/wap/hw_module_dopra.ko
    insmod /lib/modules/wap/hw_module_dsp_sdk.ko
    insmod /lib/modules/wap/hw_module_dsp.ko
fi
#if file is existed ,don't excute

# BBSP_l3_extended
if [ $l3_ex -eq 0 ]
then    
    echo "NO L3_extended!"
else 
    echo "Loading BBSP L3_extended modules: "
    insmod /lib/modules/linux/kernel/net/ipv4/ip_tunnel.ko
    insmod /lib/modules/linux/kernel/net/ipv4/gre.ko
    insmod /lib/modules/linux/kernel/net/ipv4/ip_gre.ko
    insmod /lib/modules/wap/napt.ko
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/hw_module_conenat.ko
    insmod /lib/modules/wap/l3sfwd.ko

fi
# BBSP_l3_extended end

# BBSP_Ipv6_feature
if [ $ipv6 -eq 0 ]
then    
    echo "NO ipv6!"
else 
    echo "Loading BBSP IPv6 modules: "
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/nf_defrag_ipv6.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/nf_conntrack_ipv6.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6t_rt.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6_tables.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6table_filter.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6table_mangle.ko
	insmod /lib/modules/linux/kernel/net/ipv6/netfilter/ip6t_REJECT.ko
	
	insmod /lib/modules/linux/kernel/net/ipv6/tunnel6.ko
	insmod /lib/modules/linux/kernel/net/ipv6/ip6_tunnel.ko
	insmod /lib/modules/linux/kernel/net/ipv4/tunnel4.ko
	insmod /lib/modules/linux/kernel/net/ipv6/sit.ko
	insmod /lib/modules/wap/wap_ipv6.ko
	insmod /lib/modules/wap/l3sfwd_ipv6.ko
	ip6tables -t mangle -I PREROUTING -m mark --mark 0x102001 -i br+ -j DROP
	ip6tables -A OUTPUT -o ra+ -j DROP
	ip6tables -A OUTPUT -o wl+ -j DROP
	ip6tables-restore -n < /etc/wap/sec6_init
fi
# BBSP_Ipv6_feature end

# performance start
	#echo "Loading performance monitor modules: "
	#insmod /lib/modules/wap/hw_ssp_performance.ko	
# performance end

# BBSP_hw_route
if [ $hw_route -eq 0 ]
then    
    echo "NO hw_rout!"
else 
    echo "Loading BBSP hw_rout modules: "
    insmod /lib/modules/wap/l3ext.ko
    insmod /lib/modules/wap/wap_ipv6.ko
fi

insmod /lib/modules/wap/bbsp_l3_adpt.ko
insmod /lib/modules/wap/rawip_adpt.ko
insmod /lib/modules/wap/ethoam_adpt.ko
insmod /lib/modules/wap/btv_adpt.ko

echo "Loading BBSP l2tp modules: "
insmod /lib/modules/linux/kernel/net/l2tp/l2tp_core.ko
insmod /lib/modules/linux/kernel/net/l2tp/l2tp_ppp.ko

#skb内存池
feature_double_wlan=`GetFeature HW_AMP_FEATURE_DOUBLE_WLAN`
feature_11ac=`GetFeature HW_AMP_FEATURE_11AC`
if [ $feature_double_wlan = 1 ] || [ $feature_11ac = 1 ];then
    #insmod /lib/modules/wap/skpool.ko
    echo "skpool installed ok!"
fi

#wds特性
feature_wds=`GetFeature HW_AMP_FEATURE_WDS`
if [ $feature_wds = 1 ] ;then
    insmod /lib/modules/wap/wds.ko
    echo "wds installed ok!"
fi

# BBSP_hw_route end

if [ $ssid_num -ne 0 ]
then
    insmod /lib/modules/wap/wifi_fwd.ko
fi

#start for hw_ldsp_cfg进行单板差异化配置，必须放在前面启动
iLoop=0
echo -n "Start ldsp_user..."
if [ -e /bin/hw_ldsp_cfg ]
then
  hw_ldsp_cfg &
  while [ $iLoop -lt 50 ] && [ ! -e /var/hw_ldsp_tmp.txt ] 
  do
    #echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
  
  if [ -e /var/hw_ldsp_tmp.txt ]
  then 
      rm -rf /var/hw_ldsp_tmp.txt
  fi
fi

if [ -e /bin/hw_ldsp_xpon_adpt ]
then
    hw_ldsp_xpon_adpt &
fi
#end for hw_ldsp_cfg进行单板差异化配置，必须放在前面启动

#通过特性开关来启动usb_resume进程
resume_enble=`GetFeature HW_SSMP_FEATURE_QUICKCFG`
if [ $resume_enble = 1 ];then
	echo -n "Start usb_resume..."
    usb_resume 
	break;
fi
iLoop=0
if [ -e /bin/hw_ldsp_cfg ]
then
  while [ $iLoop -lt 100 ] && [ ! -e /var/epon_up_mode.txt ] && [ ! -e /var/gpon_up_mode.txt ] && [ ! -e /var/ge_up_mode.txt ] 
  do
    #echo $iLoop
    iLoop=$(( $iLoop + 1 ))
    sleep 0.1
  done
fi
# start process ---------------------------------------
var_proc_name="ssmp bbsp igmp amp ethoam"
if [ -e /bin/app_m ]
then
	var_proc_name=$var_proc_name" app_m"
fi

if [ $pots_num -ne 0 ]
then
    var_proc_name=$var_proc_name" voice"
fi

if [ $ssid_num -ne 0 ]
then
    var_proc_name=$var_proc_name" wifi"
fi

en=`cat /var/resume_enble_cwmp`
if [ $en = 1 ];then
#    echo -n "Add cwmp to start..."
    var_proc_name=$var_proc_name" cwmp"
fi

if [ -e /var/gpon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" omci"
fi

if [ -e /var/epon_up_mode.txt ]
then
    var_proc_name=$var_proc_name" oam"
fi

echo $var_proc_name

# start 用于启动时创建共享内存，需要保证进程的个数正确即可，因此omci/oam使用oamomci替代
start $var_proc_name&
echo "Start SSMP..."
ssmp &

echo -n "Start BBSP..."
bbsp &

echo -n "Start AMP..."
amp &

echo -n "Start IGMP..."
igmp &

#echo -n "Start ethoam..."
ethoam &

if [ -e /bin/app_m ]
then
	#echo -n "Start app_m..."
	app_m &
fi

#echo -n "Start VOICE ..."
#if file is existed ,don't excute
if [ $pots_num -eq 0 ]
then    
	echo -n "Do not start VOICE..."
else 
    echo -n "Start VOICE ..."
	[ -f /bin/voice_h248 ] && voice_h248 &
	[ -f /bin/voice_sip ] && voice_sip &
	[ -f /bin/voice_mgcp ] && voice_mgcp &
	[ -f /bin/voice_h248sip ] && voice_h248sip &
fi

if [ $en = 1 ];then
#    echo -n "Start cwmp..."
    cwmp& break;
fi

#end first --------------------------------------------

if [ -e /var/gpon_up_mode.txt ]
then
    #echo -n "Start OMCI..."
    omci &
fi 

if [ -e /var/epon_up_mode.txt ]
then
    #echo -n "Start OAM..."
    oam &
fi

if [ $ssid_num -ne 0 ]
then
    echo -n "Start WIFI..."
    wifi &
fi

#echo -n "Start ProcMonitor..."
while true; do 
    sleep 1
    # 如果ssmploadconfig文件存在，表示消息服务启动成功，可以启动PM进程了
    if [ -f /var/ssmploadconfig ]; then
	    if [ $pots_num -eq 0 ] ; then
	    	echo "Start ProcMonitor without voice ..."
	        procmonitor ssmp amp & break
	    elif [ -f /bin/voice_h248 ] ; then
	    	echo "Start ProcMonitor with h248 ..."
	        procmonitor ssmp amp voice_h248 & break
	    elif [ -f /bin/voice_mgcp ] ; then
	    	echo "Start ProcMonitor with mgcp ..."
	        procmonitor ssmp amp voice_mgcp & break
	    elif [ -f /bin/voice_sip ] ; then
	    	 echo "Start ProcMonitor with sip ..."
	         procmonitor ssmp amp voice_sip & break
	    elif [ -f /bin/voice_h248sip ] ; then
	    	echo "Start ProcMonitor with h248sip ..."
	   		procmonitor ssmp amp voice_h248sip & break     
	  	else
	    	echo "Start ProcMonitor only ..."
	    	procmonitor ssmp amp & break
	   	fi
	fi
done &

#iODN产品需要关闭printk打印
printk_enble=`GetFeature HW_SSMP_FEATURE_PRINTK_SILENCE`
if [ $printk_enble == 1 ];then
    echo 0 > /proc/sys/kernel/printk 
fi

# After system up, drop the page cache.
while true; do sleep 30 ; echo 3 > /proc/sys/vm/drop_caches ; echo "Dropped the page cache."; break; done &

while true; do sleep 40 ; mu& break; done &

# 延后启动的进程
while true; do sleep 30; apm& break; done &

#insmod y1731 ko for 5115S/H
var_soc_attr=`GetChipDes`
var_soc_type=`echo $var_soc_attr | sed 's/.*\"SD//'| sed 's/V[0-9]*\"//' | tr -d '[\015]'`
echo "current soc is $var_soc_type"
feature_1731_enble=`GetFeature BBSP_FT_1731`
if [ $feature_1731_enble = 1 ];then
	if [ "${var_soc_type:0:5}" == "5115S" ] || [ "${var_soc_type:0:5}" == "5115H" ] ; then
		insmod /lib/modules/hisi_sdk/hi_kit.ko
		echo "hi_kit installed ok!"
	fi
fi

#通过特性开关来启动usb_mngt进程
usb_enble=`GetFeature HW_SSMP_FEATURE_USB`
if [ $usb_enble = 1 ];then
	while true;
	do
		sleep 20
		echo -n "Start usb_mngt..."
		usb_mngt& break;
	done &
fi 


while true; do
    sleep 10
    if [ -f /var/ssmploaddata ] ; then
        ldspcli& break; 
    fi
done &

#延时20秒，保证可以取得正确feature，从而保证WEB进程启动正常
sleep 20

#通过特性开关来启动WEB进程
resume_enble=`GetFeature HW_SSMP_FEATURE_WEB`
if [ $resume_enble = 1 ];then
	while true; do sleep 10; 
		if [ -f /var/ssmploaddata ] ; then
			web& break; 
		fi
	done &
fi

if [ $ssid_num -ne 0 ];then
    while true; do sleep 10; 
		if [ -f /var/ssmploaddata ] ; then
			udm& break; 
		fi
	done &
fi
# Print system process status for debug.
#ps

