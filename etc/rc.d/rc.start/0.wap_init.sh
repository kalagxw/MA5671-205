#!/bin/sh

# 修复用户态非对齐的指令问题
echo 2 > /proc/cpu/alignment

# 内存不足(OOM)时直接panic
echo 2 > /proc/sys/vm/panic_on_oom

# panic时3秒再复位系统，可以将一些必要的信息打印出来
echo 3 > /proc/sys/kernel/panic

# mount jffs2文件系统，需要移到产品侧，但Log是写在flash中的，存在依赖
#echo "Mount the JFFS2 file system: "
var_index=$(cat /proc/mtd | grep jffs2cfg) 
if [ "$var_index" != "" ]; then
	var_index=$(echo $var_index | cut -d ":" -f 1 | cut -c 4-)
	mount -t jffs2 /dev/mtdblock$var_index /mnt/jffs2
fi

# 读取小型化配置
cut_ver=$(cat /etc/wap/hw.wap.ssp.config | grep HW_WAP_CUT_VERSION | cut -d" " -f2)

if [ "$cut_ver" = "1" ] ; then
# calc used start
	CalcUsedMem "system" "wap"
# calc used end
fi

# 加载平台封装的GPL函数
insmod /lib/modules/wap/hw_ssp_gpl.ko

# 加载平台基础KO
insmod /lib/modules/wap/hw_ssp_basic.ko

# 如果不是小型化，就启动打印记录和msgread进程
if [ "$cut_ver" != "1" ] ; then
	# 启动kmsgreader读取打印信息
	kmsgread &
	
	# 初始化串口打印跟踪记录，60秒以后关闭记录
	echo !path "/var/init_debug.txt" > /proc/wap_proc/tty;
	echo !start > /proc/wap_proc/tty;
	while true; do sleep 60; echo !stop > /proc/wap_proc/tty; echo !path "/var/console.log" > /proc/wap_proc/tty; break; done &	
fi

# 2.6内核软件狗，1.5秒检测，0.5秒释放，打印调用栈信息
#echo 150 50 1 > /proc/softlockup
#cat /proc/softlockup

# 3.10内核软件狗，1.5秒检测，0.5秒释放，打印调用栈信息
echo 0 > /proc/sys/kernel/watchdog
echo 1 500 > /proc/sys/kernel/watchdog_thresh

# 加入dm ko
insmod /lib/modules/wap/hw_smp_dm.ko

# 高端内存
insmod /lib/modules/wap/hw_himem_soc_config.ko
insmod /lib/modules/wap/hw_ssp_depend.ko

# 如果不是小型化，就加载扩展ko和RTOS提供的实时系统监控ko（路径后续可能会变）
if [ "$cut_ver" != "1" ] ; then
	insmod /lib/modules/wap/hw_ssp_extend.ko
#	insmod /lib/modules/linux/rsm.ko
fi

if [ "$cut_ver" = "1" ] ; then
# calc used start
	CalcUsedMem "ssmp" "wap"
# calc used end
fi

#在var目录生成passwd文件
cp /etc/wap/passwd /var/ -rf
chmod 700 /var/passwd
cp /etc/wap/group /var/ -rf
chmod 700 /var/group

# 密码文件OK以后，才能正确的修改权限
chown osgi:osgi /var/osgi
chown :cplugin  /var/cplugin
