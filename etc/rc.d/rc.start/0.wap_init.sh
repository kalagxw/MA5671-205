#!/bin/sh

# �޸��û�̬�Ƕ����ָ������
echo 2 > /proc/cpu/alignment

# �ڴ治��(OOM)ʱֱ��panic
echo 2 > /proc/sys/vm/panic_on_oom

# panicʱ3���ٸ�λϵͳ�����Խ�һЩ��Ҫ����Ϣ��ӡ����
echo 3 > /proc/sys/kernel/panic

# mount jffs2�ļ�ϵͳ����Ҫ�Ƶ���Ʒ�࣬��Log��д��flash�еģ���������
#echo "Mount the JFFS2 file system: "
var_index=$(cat /proc/mtd | grep jffs2cfg) 
if [ "$var_index" != "" ]; then
	var_index=$(echo $var_index | cut -d ":" -f 1 | cut -c 4-)
	mount -t jffs2 /dev/mtdblock$var_index /mnt/jffs2
fi

# ��ȡС�ͻ�����
cut_ver=$(cat /etc/wap/hw.wap.ssp.config | grep HW_WAP_CUT_VERSION | cut -d" " -f2)

if [ "$cut_ver" = "1" ] ; then
# calc used start
	CalcUsedMem "system" "wap"
# calc used end
fi

# ����ƽ̨��װ��GPL����
insmod /lib/modules/wap/hw_ssp_gpl.ko

# ����ƽ̨����KO
insmod /lib/modules/wap/hw_ssp_basic.ko

# �������С�ͻ�����������ӡ��¼��msgread����
if [ "$cut_ver" != "1" ] ; then
	# ����kmsgreader��ȡ��ӡ��Ϣ
	kmsgread &
	
	# ��ʼ�����ڴ�ӡ���ټ�¼��60���Ժ�رռ�¼
	echo !path "/var/init_debug.txt" > /proc/wap_proc/tty;
	echo !start > /proc/wap_proc/tty;
	while true; do sleep 60; echo !stop > /proc/wap_proc/tty; echo !path "/var/console.log" > /proc/wap_proc/tty; break; done &	
fi

# 2.6�ں��������1.5���⣬0.5���ͷţ���ӡ����ջ��Ϣ
#echo 150 50 1 > /proc/softlockup
#cat /proc/softlockup

# 3.10�ں��������1.5���⣬0.5���ͷţ���ӡ����ջ��Ϣ
echo 0 > /proc/sys/kernel/watchdog
echo 1 500 > /proc/sys/kernel/watchdog_thresh

# ����dm ko
insmod /lib/modules/wap/hw_smp_dm.ko

# �߶��ڴ�
insmod /lib/modules/wap/hw_himem_soc_config.ko
insmod /lib/modules/wap/hw_ssp_depend.ko

# �������С�ͻ����ͼ�����չko��RTOS�ṩ��ʵʱϵͳ���ko��·���������ܻ�䣩
if [ "$cut_ver" != "1" ] ; then
	insmod /lib/modules/wap/hw_ssp_extend.ko
#	insmod /lib/modules/linux/rsm.ko
fi

if [ "$cut_ver" = "1" ] ; then
# calc used start
	CalcUsedMem "ssmp" "wap"
# calc used end
fi

#��varĿ¼����passwd�ļ�
cp /etc/wap/passwd /var/ -rf
chmod 700 /var/passwd
cp /etc/wap/group /var/ -rf
chmod 700 /var/group

# �����ļ�OK�Ժ󣬲�����ȷ���޸�Ȩ��
chown osgi:osgi /var/osgi
chown :cplugin  /var/cplugin
