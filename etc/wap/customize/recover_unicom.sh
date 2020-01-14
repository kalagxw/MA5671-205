#! /bin/sh

# 写入一个SSID的recover脚本，该脚本通过读取 /mnt/jffs2/customizepara.txt 
# 文件中的定制信息，来将定制信息写入ctree中

# 定制脚本信息文件，该文件名固定，不能更改
var_customize_file=/mnt/jffs2/customizepara.txt
var_pack_temp_dir=/bin/

# 定制信息写入文件，该文件通过tar包解压后复制产生,
# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"

var_userPwd=""
var_ssid=""
var_wpa=""

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
	read -r var_userPwd var_ssid var_wpa < $var_customize_file
    if [ 0 -ne $? ]
    then
        echo "Failed to read spec info!"
        return 1
    fi
    return
}

HW_Script_SetVoiceDatToFile()
{
	var_nod_ssmppdt=InternetGatewayDevice.X_HW_SSMPPDT
	var_nod_deviceinfo=InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo

	var_voice_type="0"
	
	#如果不存在"/mnt/jffs2/customize.txt"文件则直接返回
    if [ ! -f "$var_jffs2_customize_txt_file" ]
    then
        return 0
    fi
    
    read var_bin_ft_word var_cfg_ft_word1 < $var_jffs2_customize_txt_file
    if [ 0 -ne $? ]
    then
        return 1
    fi
    
    var_cfg_ft_word=$(echo $var_cfg_ft_word1 | tr a-z A-Z)
    
    #如果配置特征字中没有_SIP则直接返回，重定向到/dev/null作用是不显示echo内容
    echo $var_cfg_ft_word | grep -iE "_SIP" > /dev/null	
	if [ $? == 0 ]
    then 
        var_voice_type="1"
	fi 
    #如果配置特征字中没有_H248则直接返回，重定向到/dev/null作用是不显示echo内容
    echo $var_cfg_ft_word | grep -iE "_H248" > /dev/null	
	if [ $? == 0 ]
    then
        var_voice_type="2"
	fi 
	
	if [ "0" = $var_voice_type ]
	then
	    return 0
    fi
    
    #如果没有对象InternetGatewayDevice.X_HW_SSMPPDT，需先添加
    cfgtool find $var_default_ctree $var_nod_ssmppdt
    if [ 0 -ne $? ]
	then
	    cfgtool add $var_default_ctree $var_nod_ssmppdt NULL 
	    if [ 0 -ne $? ]
	    then
		echo "Failed to set voice ssmppdt!"
		return 1
	    fi 	
    fi
	#如果没有对象InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo，需先添加
    cfgtool find $var_default_ctree $var_nod_deviceinfo
    if [ 0 -ne $? ]
    then
    	cfgtool add $var_default_ctree $var_nod_deviceinfo NULL
	if [ 0 -ne $? ]
	then
		echo "Failed to set voice deviceinfo!"
		return 1
	fi	
	
	cfgtool add $var_default_ctree $var_nod_deviceinfo X_HW_VOICE_MODE $var_voice_type
	if [ 0 -ne $? ]
	then
		echo "Failed to add voice Type!"
		return 1
	fi	
    else
		#如果没有对象InternetGatewayDevice.X_HW_SSMPPDT.Deviceinfo.X_HW_VOICE_MODE，需先添加	
		cfgtool gettofile $var_default_ctree $var_nod_deviceinfo X_HW_VOICE_MODE
	if [ 0 -ne $? ]
	then
		cfgtool add $var_default_ctree $var_nod_deviceinfo X_HW_VOICE_MODE $var_voice_type
		if [ 0 -ne $? ]
		then
			echo "Failed to add voice Type!"
			return 1
		fi		
		else
			cfgtool set $var_default_ctree $var_nod_deviceinfo X_HW_VOICE_MODE $var_voice_type
			if [ 0 -ne $? ]
			then
				echo "Failed to set voice Type!"
				return 1
			fi		
		fi
    fi   	
}

HW_Script_SetDatToFile()
{
	var_node_web_pwd=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.X_HW_WebUserInfoInstance.1
    var_node_ssid1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1
    var_node_wpa_pwd1=InternetGatewayDevice.LANDevice.LANDeviceInstance.1.WLANConfiguration.WLANConfigurationInstance.1.PreSharedKey.PreSharedKeyInstance.1
    
    # decrypt var_default_ctree
    $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
    
    mv $var_default_ctree $var_default_ctree".gz"
    gunzip -f $var_default_ctree".gz"

    # set web user password
	cfgtool set $var_default_ctree $var_node_web_pwd Password $var_userPwd
	if [ 0 -ne $? ]
	then
		echo "Failed to set common web password!"
		return 1
	fi
	
    # set ssid1 
    cfgtool set $var_default_ctree $var_node_ssid1 SSID $var_ssid
    if [ 0 -ne $? ]
    then
        echo "Failed to set common ssid1 name!"
        return 1
    fi

    # set wpa1 password
    cfgtool set $var_default_ctree $var_node_wpa_pwd1 PreSharedKey $var_wpa
    if [ 0 -ne $? ]
    then
        echo "Failed to set common var_node_wpa_pwd1 wap password!"
        return 1
    fi
     
	#新增SIP H248预埋特性
	HW_Script_SetVoiceDatToFile
	if [ 0 -ne $? ]
	then
	    echo "Failed to set voice type!"
	    return 1
	fi	
    
    #encrypt var_default_ctree
    gzip -f $var_default_ctree
    mv $var_default_ctree".gz" $var_default_ctree
    $var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree
	
    return
}

HW_Script_CheckFileExist
[ ! $? == 0 ] && exit 1

HW_Script_ReadDataFromFile
[ ! $? == 0 ] && exit 1

HW_Script_SetDatToFile
[ ! $? == 0 ] && exit 1

echo "1" > /mnt/jffs2/telnetflag

echo "set spec info OK!"

exit 0

