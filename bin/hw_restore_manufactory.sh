#! /bin/sh

var_default_ctree=/mnt/jffs2/hw_default_ctree.xml
var_etc_def=/etc/wap/hw_default_ctree.xml
var_etc_boardinfo=/etc/wap/hw_boardinfo

var_ctree=/mnt/jffs2/hw_ctree.xml
var_ctree_bak=/mnt/jffs2/hw_ctree_bak.xml
var_rebootsave=/mnt/jffs2/cwmp_rebootsave
var_oldcrc=/mnt/jffs2/oldcrc
var_oltoldcrc=/mnt/jffs2/oltoldcrc
var_precrc=/mnt/jffs2/prevcrc
var_oltprecrc=/mnt/jffs2/oltprevcrc
var_boardinfo=/mnt/jffs2/hw_boardinfo
var_boardinfo_bak=/mnt/jffs2/hw_boardinfo.bak
var_boardinfo_temp=/mnt/jffs2/hw_boardinfo.temp
var_bms_prevxml_temp="/mnt/jffs2/hw_bms_prev.xml"
var_bms_oskvoice_temp="/mnt/jffs2/hw_osk_voip_prev.xml"
var_ftcrc_temp="/mnt/jffs2/FTCRC"
var_ftvoip_temp="/mnt/jffs2/ftvoipcfgstate"
var_dhcp_temp="/mnt/jffs2/dhcpc"
var_dhcp6_temp="/mnt/jffs2/dhcp6c"
var_DHCPlasterrwan1_temp="/mnt/jffs2/DHCPlasterrwan1"
var_DHCPlasterrwan2_temp="/mnt/jffs2/DHCPlasterrwan2"
var_DHCPlasterrwan3_temp="/mnt/jffs2/DHCPlasterrwan3"
var_DHCPlasterrwan4_temp="/mnt/jffs2/DHCPlasterrwan4"
var_DHCPstatewan1_temp="/mnt/jffs2/DHCPstatewan1"
var_DHCPstatewan2_temp="/mnt/jffs2/DHCPstatewan2"
var_DHCPstatewan3_temp="/mnt/jffs2/DHCPstatewan3"
var_DHCPstatewan4_temp="/mnt/jffs2/DHCPstatewan4"
var_DHCPoutputwan1_temp="/mnt/jffs2/DHCPoutputwan1"
var_ontfirstonline_temp="/mnt/jffs2/ontfirstonlinefile"
var_servicecfg=/mnt/jffs2/servicecfg.xml
var_commonversion=/var/common_version


# remove files
HW_Script_RemoveFile()
{
	rm -f $var_ctree
	rm -f $var_ctree_bak
	rm -f $var_rebootsave
	rm -f $var_oldcrc
	rm -f $var_oltoldcrc
	rm -f $var_precrc
	rm -f $var_oltprecrc
	rm -f $var_bms_prevxml_temp
	rm -f $var_bms_oskvoice_temp
	rm -rf $var_ftcrc_temp
 	rm -rf $var_ftvoip_temp
 	rm -rf $var_dhcp_temp
 	rm -rf $var_dhcp6_temp
	rm -rf $var_DHCPlasterrwan1_temp
 	rm -rf $var_DHCPlasterrwan2_temp
 	rm -rf $var_DHCPlasterrwan3_temp
 	rm -rf $var_DHCPlasterrwan4_temp
 	rm -rf $var_DHCPstatewan1_temp
 	rm -rf $var_DHCPstatewan2_temp
 	rm -rf $var_DHCPstatewan3_temp
 	rm -rf $var_DHCPstatewan4_temp
 	rm -rf $var_DHCPoutputwan1_temp
	
	rm -f /mnt/jffs2/usr_device.bin
	rm -f /mnt/jffs2/FTCRC
	rm -f /mnt/jffs2/ftvoipcfgstate
	rm -f /mnt/jffs2/dhcpc/wan*_request_ip
	rm -f /mnt/jffs2/emergencystatus
	rm -fr $var_ontfirstonline_temp

	rm -f $var_servicecfg
	
	rm -f /mnt/jffs2/p2ploadcfgdone
	
	return
}

# 恢复hw_boardinfo.xml的eponkey、snpassword、eponpwd、loid到默认空配置
HW_Script_Clear_Boardinfo()
{
    	#eponkey：0x00000005，eponpwd：0x00000006 snpassword：0x00000003 loid：0x00000016
    	#这个是跟DM的代码保持一致的，产品平台存在强耦合，不能随意更改
    
    	#检查boardinfo是否存在，不存在则返回
    	if [ ! -f $var_boardinfo ]; then
			echo "ERROR::$var_boardinfo is not exist!"
			return 1;
	fi

	cat $var_boardinfo | while read -r line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
		if [ "0x00000005" == $obj_id ];then
			echo "obj.id = \"0x00000005\" ; obj.value = \"\";"
		elif [ "0x00000006" == $obj_id ];then
			echo "obj.id = \"0x00000006\" ; obj.value = \"\";"
		elif [ "0x00000003" == $obj_id ];then
			echo "obj.id = \"0x00000003\" ; obj.value = \"\";"
		elif [ "0x00000016" == $obj_id ];then
			echo "obj.id = \"0x00000016\" ; obj.value = \"\";"
		elif [ "0x00000004" == $obj_id ];then
			echo "obj.id = \"0x00000004\" ; obj.value = \"\";"
		else
		    echo -E $line
		fi
	done  > $var_boardinfo_temp
	
	mv $var_boardinfo_temp $var_boardinfo
	
	return 0
}

HW_Script_IsCustomizeVersion()
{
	#检查boardinfo是否存在，不存在则返回错误
    if [ ! -f $var_boardinfo ]; then
		return 1;
	fi

	cat $var_boardinfo | while read -r line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
		if [ "0x0000001b" == $obj_id ];then
			varCfgWord=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
			if [ "$varCfgWord" = "COMMON" ] ; then
				touch $var_commonversion
				return 0
			fi
		else
		    echo -E $line
		fi
	done > /dev/null
}

# copy files
HW_Script_CopyFile()
{	
	HW_Script_IsCustomizeVersion
	#1）如果不是定制，var_etc_def拷贝为hw_ctree.xml
	#2）如果是定制，var_default_ctree不存在需要报错，存在，则拷贝此文件为hw_ctree.xml
	
	#增加延时，确保DB不保存
	echo > /var/notsavedata
	sleep 1
	
	if [ -f $var_commonversion ] ; then
	    cp -f $var_etc_def $var_ctree
		if [ 0 -ne $? ] ; then
			rm -rf /var/notsavedata
			echo "ERROR::Failed to cp $var_etc_def to hw_ctree.xml!"
			return 1
		fi
	else
		if [ -f $var_default_ctree ];then
			cp -f $var_default_ctree $var_ctree
			if [ 0 -ne $? ] ; then
				rm -rf /var/notsavedata
				echo "ERROR::Failed to cp $var_default_ctree to hw_ctree.xml!"
				return 1
			fi
		else
			rm -rf /var/notsavedata
			echo "ERROR::$var_default_ctree is not exist!"
			return 1
		fi
	fi
	
	#copy hw_boardinfo
	HW_Script_Clear_Boardinfo
	if [ 0 -ne $? ] ; then
		return 1
	fi
	
	#copy hw_boardinfo.bak
	cp -f $var_boardinfo $var_boardinfo_bak
	if [ 0 -ne $? ]
	then
		echo "ERROR::Failed to cp hw_boardinfo to hw_boardinfo.bak!"
		return 1
	fi
	
	return
}

if [ 0 -ne $# ]; then
	echo "ERROR::input para is not right!";
	return 1;
else
	#删除指定文件
	HW_Script_RemoveFile
	[ ! $? == 0 ] && exit 1

#拷贝文件
HW_Script_CopyFile
[ ! $? == 0 ] && exit 1

exit 0

fi

