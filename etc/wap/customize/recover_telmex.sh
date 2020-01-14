#! /bin/sh

#Telmex��������
#customize.sh COMMON TELMEX WIFI�û��� WIFI���� PPPOE�û��� PPPOE���� TR069�û��� TR069����  WEB����
# ���ƽű���Ϣ�ļ������ļ����̶������ܸ���
var_customize_file=/mnt/jffs2/customizepara.txt

# ������Ϣд���ļ������ļ�ͨ��tar����ѹ���Ʋ���,
# recover�ű���д����������������ʱ�ļ��н���
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml

var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/mnt/jffs2/hw_boardinfo.temp"

var_pack_temp_dir=/bin/

var_wifi_unm=""
var_wifi_pwd=""
var_pppoe_unm=""
var_pppoe_pwd=""
var_tms_unm=""
var_tms_pwd=""
var_web_unm="TELMEX" #Web�û���������������, ʹ��Ĭ��ֵTELMEX
var_web_pwd=""
var_ProvisionCode="Telmex"
var_cli_name="" 
var_cli_pwd=""

HW_Check_Boardinfo()
{
	if [ -f $var_boardinfo_file ]; then
		return 0;
	else
		echo "ERROR::$var_boardinfo_file is not exist!"
		return 1;
	fi		
}

HW_Set_ProvisionCode()
{
    #ProvisionCode��IDΪ0x00000020
    #���boardinfo�Ƿ����
    HW_Check_Boardinfo
	if [ ! $? == 0 ]
	then
		echo "ERROR::Failed to Check Boardinfo!"
		return 1
	fi

	cat $var_boardinfo_file | while read -r line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
		if [ "0x00000020" == $obj_id ];then
		    obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
		    echo $line | sed 's/'\"$obj_value\"'/'\"$var_ProvisionCode\"'/g';
		else
		    echo -E $line
		fi
	done  > $var_boardinfo_temp
	
	mv $var_boardinfo_temp $var_boardinfo_file
	
	return 0
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
	#CR20141216011�ͺ��ǡ����籦ȷ���ˣ�telmex���ƻ���ʹ��TELMEX���������֣����ֲ��䣬���Ʋ���Ϊ9�������ü���ԭ����5����7������ʽ���£�
	#customize.sh COMMON TELMEX SSID WEP_KEY PPPoE_username PPPoE_password TR069�û��� TR069���� WEB���� CLI�û��� CLI����	
	read -r var_wifi_unm var_wifi_pwd var_pppoe_unm var_pppoe_pwd var_tms_unm var_tms_pwd var_web_pwd var_cli_name var_cli_pwd< $var_customize_file
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
	var_wifi_unm_node=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
	var_wifi_pwd_node=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
	var_wifi_wep_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.WEPKey.WEPKeyInstance.1
	var_wifi_wep_pwd2=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.WEPKey.WEPKeyInstance.2
	var_wifi_wep_pwd3=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.WEPKey.WEPKeyInstance.3
	var_wifi_wep_pwd4=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.WEPKey.WEPKeyInstance.4
	var_pppoe_node=InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.1.WANPPPConnection.WANPPPConnectionInstance.1
	var_tms_node=InternetGatewayDevice.ManagementServer
	var_web_node=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.2 
	var_cli_node=InternetGatewayDevice.UserInterface.X_HW_CLIUserInfo.X_HW_CLIUserInfoInstance.1 
	#set wifi info
	# decrypt var_default_ctree
    	$var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	
	cfgtool set $var_default_ctree $var_wifi_unm_node SSID $var_wifi_unm
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common ssid name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_wifi_pwd_node PreSharedKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common wifi password!"
	    return 1
	fi
	
	#set wepkey 1--4
	cfgtool set $var_default_ctree $var_wifi_wep_pwd1 WEPKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common WEPKey password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_wifi_wep_pwd2 WEPKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common WEPKey password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_wifi_wep_pwd3 WEPKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common WEPKey password!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_wifi_wep_pwd4 WEPKey $var_wifi_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common WEPKey password!"
	    return 1
	fi
	
	#set pppoe info
	cfgtool set $var_default_ctree $var_pppoe_node Username $var_pppoe_unm
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common pppoewan name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_pppoe_node Password $var_pppoe_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common pppoewan password!"
	    return 1
	fi
	
	#set TMs info
	cfgtool set $var_default_ctree $var_tms_node Username $var_tms_unm
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common tms name!"
	    return 1
	fi
	
	cfgtool set $var_default_ctree $var_tms_node Password $var_tms_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common tms password!"
	    return 1
	fi
	
	#set web info
	cfgtool set $var_default_ctree $var_web_node Password $var_web_pwd
	if [ 0 -ne $? ]
	then
	    echo "Failed to set common web password!"
	    return 1
	fi
	
	if [ ! -z $var_cli_name ]
	then
		cfgtool set $var_default_ctree $var_cli_node Username $var_cli_name
		if [ 0 -ne $? ]
		then
			echo "Failed to set common cli name!"
			return 1
		fi	
	fi
	
	if [ ! -z $var_cli_pwd ]
	then
		cfgtool set $var_default_ctree $var_cli_node Userpassword $var_cli_pwd MD5
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
	return
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

#
HW_Set_ProvisionCode

echo "set spec info OK!!"

exit 0