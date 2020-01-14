#! /bin/sh

varcpunum=0

if [ $# -ne 0 ];then
	echo "ERROR::no need input para!";
	echo "fail!"
else
	if grep cpu_1 /proc/wap_proc/cpu_mem >/dev/null
	then 
		varcpunum=`cat /proc/cpuinfo | grep "processor" | wc -l`
		if [ $varcpunum -eq 2 ]; then
			echo "double core normal"
			echo "success!"
		    exit 1
		fi
	fi

	echo "single core normal"
	echo "success!"
    exit 1
fi

exit 1

