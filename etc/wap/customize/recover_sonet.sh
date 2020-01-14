#! /bin/sh

# 写入2个SSID的recover脚本，该脚本通过读取 /mnt/jffs2/customizepara.txt 
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

var_web_name=""
var_web_pwd=""
var_ssid1=""
var_wpa1="" 
var_ssid5=""
var_wpa5="" 

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
	read -r var_web_name var_web_pwd var_ssid1 var_wpa1 var_ssid5 var_wpa5 < $var_customize_file
	if [ 0 -ne $? ]
	then
	    echo "Failed to read spec info!"
	    return 1
	fi
	return
}

# set customize data to file
HW_Script_SetDatToFile()
{
    var_cli_name_node=InternetGatewayDevice.UserInterface.X_HW_CLIUserInfo.X_HW_CLIUserInfoInstance.1
	var_cli_pwd_node=InternetGatewayDevice.UserInterface.X_HW_CLIUserInfo.X_HW_CLIUserInfoInstance.1
	var_web_name_node=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.2
    var_web_pwd_node=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.2	
	var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_ssid5=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5
	var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	var_node_wpa_pwd5=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1

	cp $var_default_ctree $var_default_ctree_var
	# decrypt var_default_ctre
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree_var $var_temp_ctree_var
	mv $var_default_ctree_var $var_default_ctree_var".gz"
	gunzip -f $var_default_ctree_var".gz"

	#set web info
	cfgtool set $var_default_ctree_var $var_web_name_node UserName $var_web_name
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common web UserName!"
	    return 1
	fi

	#set web pwd
	cfgtool set $var_default_ctree_var $var_web_pwd_node Password $var_web_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common web password!"
	    return 1
	fi

	#set cli name
    cfgtool set $var_default_ctree_var $var_cli_name_node Username $var_web_name
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common cli name!"
	    return 1
	fi
	
	#set cli pwd
    cfgtool set $var_default_ctree_var $var_cli_pwd_node Userpassword $var_web_pwd MD5
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common cli password!"
	    return 1
	fi
	
	if [ $var_has_wifi -ne 0 ]
	then	
		# set ssid1 
		cfgtool set $var_default_ctree_var $var_node_ssid1 SSID $var_ssid1
		if [ 0 -ne $? ]
		then
			echo "Failed to set ssid1 name!"
			return 1
		fi
	
		# set wpa password 1
		cfgtool set $var_default_ctree_var $var_node_wpa_pwd1 PreSharedKey $var_wpa1
		if [ 0 -ne $? ]
		then
			echo "Failed to set common ssid1 wap password!"
			return 1
		fi
	
		# set ssid5
		cfgtool set $var_default_ctree_var $var_node_ssid5 SSID $var_ssid5
		if [ 0 -ne $? ]
		then
			echo "Failed to set ssid5 name!"
			exit 1
		fi
	
		#set wpa password5
		cfgtool set $var_default_ctree_var $var_node_wpa_pwd5 PreSharedKey $var_wpa5
		if [ 0 -ne $? ]
		then
			echo "Failed to set ssid5 wpa password!"
			exit 1
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

HW_Script_CheckHaveWIFI

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0

