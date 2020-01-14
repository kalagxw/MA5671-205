#! /bin/sh

#set CTCOM, Unicom or mobily spec parameters
#include bin and spec word
#include spec sn, common web username ssid password

# ������Ϣ�ļ�
var_customize_file=/mnt/jffs2/customizepara.txt
var_customize_file_var_path=/var/customizepara.txt
var_customize_file_not_aes=/var/customizepara_not_aes.txt
var_jffs2_customize_txt_file=/mnt/jffs2/customize.txt
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara

var_binword=""
var_cfgword=""
var_customizeinfo=""
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"

#get feature word
HW_Script_GetFtWord()
{
	if [ -f $var_jffs2_customize_txt_file ];then
	read var_binword var_cfgword < $var_jffs2_customize_txt_file
	else
		while read line;
		do			
			#�ű���"��Ϊƥ�䣬����boardinfo����Щ�ֶε�ֵ(����snpassword)��������Ϊ"�ţ�
			#��˲����������ģʽƥ��,��Ϊ����obj.value��һ����Ŀ��Ϊ��������,
			#���ָķ���һ������obj.value����ΪBinWord����CfgWord��ֵ�������ƥ�����
			#��һ����Ϊobj_id,�ڶ�����Ϊobj_value��obj_idֻ����˿��Ը��������ģʽƥ��
			obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
			obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		
			if [ "0x0000001a" == $obj_id ];then
				obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
				var_binword=$obj_value;
			elif [ "0x0000001b" == $obj_id ];then
				obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
				var_cfgword=$obj_value;
			else 
				continue
		fi
		done < $var_boardinfo_file
	fi
	return
}

# get customize info 
HW_Script_GetCustomizeInfo()
{
	if [ ! -f "$var_customize_file" ]
	then
		echo "ERROR::no customize info exist!"
		return 1
	fi
	
	# ���ǵ����֮ǰ��5���������Ƶ�jffs2�����ɵ���TelmexCusomizePara
	# �˴��ݲ��޸�
	if [ "TELMEX" == $var_cfgword ] && [ -f $var_customize_telmex ]
	then
		read var_customizeinfo < $var_customize_telmex
		if [ 0 -eq $? ]
		then
			return 0
		fi
	fi
	
	#�ж��Ƿ��Ѿ�����
	var_is_en=0
	
	cp $var_customize_file $var_customize_file_var_path

	var_str=$(hexdump $var_customize_file_var_path | grep 0000000)
	var_first_four=$(echo $var_str | cut -b 9-12)
	var_last_four=$(echo $var_str | cut -b 14-17)

	if [ $var_first_four == 0001 ]; then
		if [ $var_last_four == 0000 ]; then
			var_is_en=1
			
		else
			var_is_en=0
		fi
	else
		var_is_en=0
	fi
	
	if [ $var_is_en == 1 ]; then
		aescrypt2 1 $var_customize_file_var_path $var_customize_file_not_aes
		
		#sprint the spec content
		read var_customizeinfo < $var_customize_file_var_path
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	
		#deal for read end
		rm -rf $var_customize_file_var_path
	else
		#sprint the spec content
		read var_customizeinfo < $var_customize_file
		if [ 0 -ne $? ]
		then
			echo "ERROR:Failed to spec info"
			return 1
		fi
	fi

	return
}

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
else
#
HW_Script_GetFtWord
[ ! $? == 0 ] && exit 1

#
HW_Script_GetCustomizeInfo
[ ! $? == 0 ] && exit 1

echo "$var_binword $var_cfgword $var_customizeinfo" 

echo "success!"

exit 0 
fi

