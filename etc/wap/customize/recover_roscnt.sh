#! /bin/sh

var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_boardinfo_temp="/mnt/jffs2/hw_boardinfo.temp"
var_ProvisionCode="RTCM.MRFC"

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
    #ProvisionCode的ID为0x00000020
    #检查boardinfo是否存在
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

var_customize_path=/etc/wap/customize

$var_customize_path/recover_set_ssid1.sh

HW_Set_ProvisionCode


exit 0



