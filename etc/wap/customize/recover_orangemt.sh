#! /bin/sh

# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_boardtype=""
var_specsn=""
var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_pack_temp_dir=/bin/
var_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_customize_path=/etc/wap/customize

HW_Script_GetBoardType()
{
	#调用ontinfo工具获取产品类型
	var_boardtype=`ontinfo -s -b`
	var_len=${#var_boardtype}
	let var_len=var_len-1
	var_boardtype=`expr substr $var_boardtype 1 $var_len`
}

# get ont SN
HW_Script_GetONTSN()
{
	while read line;
	do
		obj_id_temp=`echo $line | sed 's/\(.*\)obj.value\(.*\)/\1/g'`
		obj_id=`echo $obj_id_temp | sed 's/\(.*\)"\(.*\)"\(.*\)/\2/g'`
		if [ "0x00000002" == $obj_id ];then
			obj_value=`echo $line | sed 's/\(.*\)"\(.*\)"\(.*\)"\(.*\)"\(.*\)/\4/g'`
			var_specsn=$obj_value
			break
		fi
	done < $var_boardinfo_file
	
	if [ $var_specsn == "" ]
	then
		echo "ERROR::Failed to get cur_sn info!"
		exit 1
	fi
	return
}

HW_Script_Set_MngtInfo()
{
  # decrypt var_default_ctree
  $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
  mv $var_default_ctree $var_default_ctree".gz"
  gunzip -f $var_default_ctree".gz"

	cfgtool set $var_default_ctree InternetGatewayDevice.ManagementServer Username "00259E-$var_boardtype-$var_specsn"
	cfgtool set $var_default_ctree InternetGatewayDevice.ManagementServer Password "$var_specsn"

	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree
}

HW_Script_GetBoardType
[ ! $? == 0 ] && exit 1

HW_Script_GetONTSN
[ ! $? == 0 ] && exit 1

HW_Script_Set_MngtInfo
[ ! $? == 0 ] && exit 1

$var_customize_path/recover_set_ssid1.sh

exit 0
