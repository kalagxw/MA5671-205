#! /bin/sh

# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/mnt/jffs2/customizepara.txt
var_wifi_ssid=""
var_wifi_pwd=""
var_web_pwd=""

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_pack_temp_dir=/bin/

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
	read var_wifi_ssid var_wifi_pwd var_web_pwd < $var_customize_file
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
	var_web_node=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1
	
	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	
	#set ssid
	cfgtool set $var_default_ctree $var_node_ssid SSID $var_wifi_ssid
	if [ 0 -ne $? ]
	then
		echo "ERROR::Failed to set hungary SSID!"
		exit 1
	fi
	
	#set wpa password	
	cfgtool set $var_default_ctree $var_node_wpa_pwd PreSharedKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
		echo "ERROR::Failed to set hungary wpa password!"
		exit 1
	fi
	
	#set web password	
	cfgtool set $var_default_ctree $var_web_node Password $var_web_pwd
	if [ 0 -ne $? ]
	then
		echo "Failed to set common web password!"
		exit 1
	fi
	
	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree

	return 0
}

HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "set spec info OK!"

exit 0

