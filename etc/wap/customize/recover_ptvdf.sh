#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /mnt/jffs2/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中
#customize.sh COMMON_WIFI XXX SSID WPA密码
# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/mnt/jffs2/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree_var=/var/hw_default_ctree.xml
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree_var=/var/hw_temp_ctree.xml
var_pack_temp_dir=/bin/

var_ssid=""
var_ssid1=""
var_ssid2=""
var_ssid3=""
var_ssid4=""
var_wpa="" 
var_para=""

#默认是不带wifi
var_has_wifi=0

#判断是否包含wifi
HW_Script_CheckHaveWIFI()
{	
	var_has_wifi=`cat /proc/wap_proc/pd_static_attr | grep -w wlan_num | grep -o \".*[0-9].*\" | grep -o "[0-9]"`  
}

# check the customize file
HW_Script_CheckFileExist()
{
	if [ ! -f "$var_customize_file" ] ;then
	    echo "ERROR::customize file is not existed."
            return 1
	fi
	return 0
}

# read data from customize file
HW_Script_ReadDataFromFile()
{
	#有wifi才需要读
	if [ $var_has_wifi -ne 0 ]
	then	
		read -r var_ssid1 var_ssid2 var_ssid3 var_ssid4 var_wpa < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "Failed to read spec info!"
			return 1
		fi

		if [ ! -z $var_wpa ]
		then
			var_ssid="$var_ssid1 $var_ssid2 $var_ssid3 $var_ssid4"
		else
			var_wpa=$var_ssid2
			var_ssid=$var_ssid1
		fi

		return
	fi
}

# set customize data to file
HW_Script_SetDatToFile()
{
	var_node_ssid=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	
	if [ $var_has_wifi -eq 0 ]
	then
		return
	fi

	# decrypt var_default_ctre
	cp $var_default_ctree $var_default_ctree_var
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree_var $var_temp_ctree_var
	mv $var_default_ctree_var $var_default_ctree_var".gz"
	gunzip -f $var_default_ctree_var".gz"

	#判断密码即可
	if [ ! -z $var_wpa ]
	then
		# set ssid 
		cfgtool set $var_default_ctree_var $var_node_ssid SSID "$var_ssid"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common ssid name!"
		    return 1
		fi

		# set wpa password
		cfgtool set $var_default_ctree_var $var_node_wpa_pwd PreSharedKey "$var_wpa"
		if [ 0 -ne $? ]
		then
		    echo "Failed to set common ssid wap password!"
		    return 1
		fi
	fi
	
	#encrypt var_default_ctree
	gzip -f $var_default_ctree_var
	mv $var_default_ctree_var".gz" $var_default_ctree_var
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree_var $var_temp_ctree_var
	mv $var_default_ctree_var $var_default_ctree
	return
}

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#检查是否包含wifi
HW_Script_CheckHaveWIFI

#读取定制参数
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0




