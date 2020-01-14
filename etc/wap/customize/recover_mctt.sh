#! /bin/sh

# д��һ��SSID��recover�ű����ýű�ͨ����ȡ /mnt/jffs2/customizepara.txt 
# �ļ��еĶ�����Ϣ������������Ϣд��ctree��

# ���ƽű���Ϣ�ļ������ļ����̶������ܸ���
var_customize_file=/mnt/jffs2/customizepara.txt
var_custunpara_file=/mnt/jffs2/custunpara.txt

# ������Ϣд���ļ������ļ�ͨ��tar����ѹ���Ʋ���,
# recover�ű���д����������������ʱ�ļ��н���
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_specsn=""
var_userPwd=""
var_ssid=""
var_wpa="" 

var_pack_temp_dir=/bin/

# �ж�custunpara.txt�ļ��Ƿ����
HW_IsCustunpara_Exist()
{
	if [ -f $var_custunpara_file ]
	then
    	return 0
	else
    	echo "ERROR::custunpara.txt is not existed."
    	return 1
	fi
	
	return
}

# �����ϵĶ����ļ������µĶ����ļ�
HW_Create_Customize()
{
	cat $var_custunpara_file |
	while IFS=: read para1 para2
	do
		echo $para1 > $var_customize_file
	done

    read var1 var2 var3 var4 < $var_customize_file
    echo "$var3 $var4" > $var_customize_file
    return
}

# check the customize file
HW_Script_CheckFileExist()
{
	if [ ! -f "$var_customize_file" ]
	then
		HW_IsCustunpara_Exist
		if [ 0 -ne $? ]
		then
			return 1
		fi
		HW_Create_Customize
	fi
	return 0
}

# read data from customize file
HW_Script_ReadDataFromFile()
{
	read var_ssid var_wpa < $var_customize_file
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

    # decrypt var_default_ctre
    $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
	mv $var_default_ctree $var_default_ctree".gz"
	gunzip -f $var_default_ctree".gz"
	
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

echo "set spec info OK!"

exit 0

