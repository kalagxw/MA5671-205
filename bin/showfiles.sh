#!/bin/sh
# cat 封装，只能读取/var、 /proc、 /tmp 目录下面的文件内容
CheckFilePath()
{
    path=$1
    echo $1 | grep '\.\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '/\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '\./' > /dev/null
	if [ 0 == $? ]
	then
        return 1;		
	fi
    
	return 0;
}

DealWithJffsFile()
{
	case "$1" in
		 *hard_version* | *cwmp_rebootsave* | *reboot_info* | *main_version* | *board_type* | *optic_par_debug*  | *flashtestresult* | *equip_aging_temperature* | *panicinfo* )  cat $1;;
		 *xmlcfgerrorcode* ) cat $1
		  echo ""
		  echo "show hex:"
		  hexdump $1;;
		 * ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac
	
	return $?
}

DealWithProcFile()
{
	case "$1" in
		/proc/[0-9]*/* |  *buddyinfo* | *bus* | *cmdline* | *cpu* | *cpuinfo* | *crypto* | *devices* | *diskstats* | *driver* | *execdomains* | *filesystems* | *fs* |\
		*interrupts* | *iomem* | *ioports* | *irq* |    *kallsyms* | *kmsg* | *kpagecount* | *kpageflags* | *loadavg* | *locks* | *meminfo* | *misc* | \
		*modules* | *mounts* | *mtd* | *net* | *pagetypeinfo* |  *partitions* | *sched_debug* | *schedstat* | *self* | *simple_config* | *slabinfo* | \
		*softirqs* | *softlockup* | *stat* | *sys* | *sysrq-trigger* | *sysvipc* | *timer_list* | *tty* | *uptime* | *version* | *vmallocinfo* | \
		*vmstat* | *zoneinfo* ) cat $1;;
		* ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac

	return $?
}

DealWithVarFile()
{
	case "$1" in
		*dhcpd* | *dnsmasq* | *hosts* | *wan* | *dnsv6* ) cat $1;;
		* ) echo "ERROR::The directory or file is wrong!"; return 1;;
	esac

	return $?
}

if [ 1 -ne $# ]; 
then
    echo "ERROR::input para is not right!"
    return 1;	
else
    CheckFilePath $1
	if [ 0 -ne $? ]
	then
        echo "ERROR::input para is not right!"
        return 1;		
	fi
	
    case "$1" in
     *proc*  ) DealWithProcFile $1;;
     *jffs2* ) DealWithJffsFile $1;;
     *var* ) DealWithVarFile $1;;
     * ) echo "ERROR::The directory or file is wrong!"; return 1;;
    esac

    return $?
fi
