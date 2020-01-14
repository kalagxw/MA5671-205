#! /bin/sh

# 西北电信的定制脚本，需要设置BBSP的节点X_HW_VenderClassID

# recover脚本的写入操作都是在这个临时文件中进行
var_default_ctree=/mnt/jffs2/customize_xml/hw_default_ctree.xml
var_boardtype=""

var_temp_ctree=/mnt/jffs2/customize_xml/hw_default_ctree_tem.xml
var_pack_temp_dir=/bin/

var_customize_path=/etc/wap/customize

HW_Script_GetBoardType()
{
	#调用ontinfo工具获取产品类型
	var_boardtype=`ontinfo -s -b`
	var_len=${#var_boardtype}
	let var_len=var_len-1
	var_boardtype=`expr substr $var_boardtype 1 $var_len`
}

HW_Script_Set_VenderID()
{
  # decrypt var_default_ctree
  $var_pack_temp_dir/aescrypt2 1 $var_default_ctree $var_temp_ctree
  mv $var_default_ctree $var_default_ctree".gz"
  gunzip -f $var_default_ctree".gz"

	cfgtool set $var_default_ctree InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.2.WANIPConnection.WANIPConnectionInstance.1 X_HW_VenderClassID "VOIP_$var_boardtype"
	cfgtool set $var_default_ctree InternetGatewayDevice.WANDevice.WANDeviceInstance.1.WANConnectionDevice.WANConnectionDeviceInstance.3.WANIPConnection.WANIPConnectionInstance.1 X_HW_VenderClassID "ACS_$var_boardtype"

	#encrypt var_default_ctree
	gzip -f $var_default_ctree
	mv $var_default_ctree".gz" $var_default_ctree
	$var_pack_temp_dir/aescrypt2 0 $var_default_ctree $var_temp_ctree
	echo "3" > /mnt/jffs2/telnetflag
}

HW_Script_GetBoardType
[ ! $? == 0 ] && exit 1

HW_Script_Set_VenderID
[ ! $? == 0 ] && exit 1

echo "1" > /mnt/jffs2/telnetflag

$var_customize_path/recover_set_ssid1.sh

exit 0
