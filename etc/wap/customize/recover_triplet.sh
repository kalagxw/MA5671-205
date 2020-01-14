#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /mnt/jffs2/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中

# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/mnt/jffs2/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_pack_temp_dir=/bin/

var_ssid=""
var_wpa="" 
var_webadmin_pwd=""



# check the customize file
HW_Script_CheckFileExist()
{
	if [ ! -f "$var_customize_file" ]
	then
		echo "ERROR::customize file is not existed."
		return 1
	fi
	return 0
}

# read data from customize file
HW_Script_ReadDataFromFile()
{
	read -r var_ssid var_wpa var_webadmin_pwd< $var_customize_file
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
	var_node_ssid=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_node_wpa_pwd=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	var_web_pwd_node=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.2
	var_cli_pwd_node=InternetGatewayDevice.UserInterface.X_HW_CLIUserInfo.X_HW_CLIUserInfoInstance.1
	
	#set web user and password
	password_byte1=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000a | cut -d ":" -f 5)
	password_byte2=$(cat /mnt/jffs2/hw_boardinfo | grep 0x0000000a | cut -d ":" -f 6 | cut -c 1-2)
	var_web_pwd=$password_byte1$password_byte2
	
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"

	if [ -n "$var_ssid" ] ; then
		#set web info
		cfgtool set $var_default_ctree $var_web_pwd_node Password $var_webadmin_pwd
		if [ 0 -ne $? ]
		then
			echo "Failed to set common web password!"
			return 1
		fi

		#set cli pwd
		cfgtool set $var_default_ctree $var_cli_pwd_node Userpassword $var_webadmin_pwd MD5
		if [ 0 -ne $? ]
		then
			echo "Failed to set common cli password!"
			return 1
		fi		
		
		# set ssid 
		cfgtool set $var_default_ctree $var_node_ssid SSID $var_ssid
		if [ 0 -ne $? ]
		then
			echo "Failed to set common ssid name!"
			return 1
		fi

		# set wpa password
		cfgtool set $var_default_ctree $var_node_wpa_pwd PreSharedKey $var_wpa
		if [ 0 -ne $? ]
		then
			echo "Failed to set common ssid wap password!"
			return 1
		fi
	else
		#set web info
		cfgtool set $var_default_ctree $var_web_pwd_node Password $var_web_pwd
		if [ 0 -ne $? ]
		then
			echo "ERROR::Failed to set common web password!"
			return 1
		fi
		
		#set cli pwd
		cfgtool set $var_default_ctree $var_cli_pwd_node Userpassword $var_web_pwd MD5
		if [ 0 -ne $? ]
		then
			echo "Failed to set common cli password!"
			return 1
		fi	
	fi
		
	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree

	return 0
}

#
HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

#
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0

