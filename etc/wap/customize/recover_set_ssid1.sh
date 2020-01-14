#! /bin/sh

# д��һ��SSID��recover�ű����ýű�ͨ����ȡ /mnt/jffs2/customizepara.txt 
# �ļ��еĶ�����Ϣ������������Ϣд��ctree��
#customize.sh COMMON_WIFI XXX SSID WPA����
# ���ƽű���Ϣ�ļ������ļ����̶������ܸ���
var_customize_file=/mnt/jffs2/customizepara.txt

# ������Ϣд���ļ������ļ�ͨ��tar����ѹ���Ʋ���,
# recover�ű���д����������������ʱ�ļ��н���
var_default_ctree_var=/var/hw_default_ctree.xml
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree_var=/var/hw_temp_ctree.xml
var_pack_temp_dir=/bin/

var_ssid=""
var_wpa="" 
var_para=""

#Ĭ���ǲ���wifi
var_has_wifi=0

#�ж��Ƿ����wifi
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
	#��wifi����Ҫ��
	if [ $var_has_wifi -ne 0 ]
	then	
		read -r var_para < $var_customize_file
		echo $var_para | grep \" > /dev/null	
		if [ $? == 0 ]
		then
			var_ssid=`echo $var_para | cut -d \" -f2 `
			len=`expr length "\"$var_ssid\"  "`
			var_wpa=`echo $var_para | cut -b $len-`
		else
			read -r var_ssid var_wpa < $var_customize_file
		fi 
		
		if [ 0 -ne $? ]
		then
			echo "Failed to read spec info!"
			return 1
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

	#�ж����뼴��
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

#����Ƿ����wifi
HW_Script_CheckHaveWIFI

#��ȡ���Ʋ���
HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

#
HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "4" > /mnt/jffs2/telnetflag
echo "set spec info OK!"

exit 0

