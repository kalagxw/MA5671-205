#! /bin/sh

# 写入三个SSID的recover脚本，该脚本通过读取 /mnt/jffs2/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中

# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/mnt/jffs2/customizepara.txt

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
CURRENT_DIR=$PWD
HW_WAP_TRUNK_ROOT=$CURRENT_DIR/..
HW_WAP_PLAT_ROOT=$HW_WAP_TRUNK_ROOT/WAP
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_pack_temp_dir=/bin/
var_ssid1_pwd=""
var_ssid2_pwd=""
var_ssid3_pwd=""
var_ssid5_pwd=""
var_pppoe_un=""
var_pppoe_pwd=""

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
	read -r var_ssid1_pwd var_ssid2_pwd var_ssid3_pwd var_ssid5_pwd var_pppoe_un var_pppoe_pwd var_tmp < $var_customize_file
	if [ 0 -ne $? ]
	then
	    echo "Failed to read spec info!"
	    return 1
	fi
	
	#如果定制参数不为空说明是用户输入,否则按照特定的格式自动生成
	if [ "$var_ssid1_pwd" == "" ] || [ "$var_ssid2_pwd" == "" ] || [ "$var_ssid3_pwd" == "" ] || [ "$var_ssid5_pwd" == "" ] \
	  || [ "$var_pppoe_un" == "" ] || [ "$var_pppoe_pwd" == "" ]
	then
		echo "Failed to read spec info!"
	    return 1
	fi
	return 0
}

# set customize data to file
HW_Script_SetDatToFile()
{ 
	var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	var_node_wep_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2.WEPKey.WEPKeyInstance.1
	var_node_wep_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2.WEPKey.WEPKeyInstance.2
	var_node_wep_pwd3=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2.WEPKey.WEPKeyInstance.3
	var_node_wep_pwd4=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.2.WEPKey.WEPKeyInstance.4
	var_node_wpa_pwd3=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.3.PreSharedKey.PreSharedKeyInstance.1
	var_node_wpa_pwd5=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.5.PreSharedKey.PreSharedKeyInstance.1
	var_node_pppoe_wan=InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.2.WANPPPConnection.WANPPPConnectionInstance.1

  # decrypt var_default_ctree
  $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"

	# set ssid1_pwd 
	cfgtool set $var_default_ctree $var_node_wpa_pwd1 PreSharedKey $var_ssid1_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid1 password!"
	    return 1
	fi
	
	# set ssid2_pwd wep1
	cfgtool set $var_default_ctree $var_node_wep_pwd1 WEPKey $var_ssid2_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 wep1 password!"
	    return 1
	fi
	
	# set ssid2_pwd wep2
	cfgtool set $var_default_ctree $var_node_wep_pwd2 WEPKey $var_ssid2_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 wep2 password!"
	    return 1
	fi
	
	# set ssid2_pwd wep3
	cfgtool set $var_default_ctree $var_node_wep_pwd3 WEPKey $var_ssid2_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 wep3 password!"
	    return 1
	fi
	
	# set ssid2_pwd wep4
	cfgtool set $var_default_ctree $var_node_wep_pwd4 WEPKey $var_ssid2_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid2 wep4 password!"
	    return 1
	fi
	
	# set ssid3_pwd 
	cfgtool set $var_default_ctree $var_node_wpa_pwd3 PreSharedKey $var_ssid3_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid3 password!"
	    return 1
	fi
	
	# set ssid5_pwd 
	cfgtool set $var_default_ctree $var_node_wpa_pwd5 PreSharedKey $var_ssid5_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid5 password!"
	    return 1
	fi
	
	#set pppoe username
	cfgtool set $var_default_ctree $var_node_pppoe_wan Username $var_pppoe_un
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common pppoe wan name!"
	    return 1
	fi
	
	#set pppoe pwd
	cfgtool set $var_default_ctree $var_node_pppoe_wan Password $var_pppoe_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common pppoe wan password!"
	    return 1
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

echo "set spec info OK!!"

exit 0