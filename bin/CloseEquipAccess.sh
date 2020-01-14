#! /bin/sh
# 全局的文件变量
var_program_key_file="/usr/bin/bin/program_key"
var_pack_temp_dir=/bin
var_customize_xml_tar=/mnt/jffs2/customize_xml.tar.gz
var_customize_xml_tmp_tar=/mnt/jffs2/customize_xml_tmp.tar.gz
var_ClosedTemp_dir=/mnt/jffs2/ClosedTemp
var_ClosedTemp_XML_name=/mnt/jffs2/ClosedTemp/hw_opt.xml
var_ClosedTemp_XML_name_tmp=/mnt/jffs2/ClosedTemp/hw_opt_tmp.xml
var_OptFileName=""
var_OptFilePatch=""
var_OptFiletmpPatch=""


#解密解压XML
HW_PrevOpt_xml()
{
	# decrypt var_default_ctree
        $var_pack_temp_dir/aescrypt2 1 $var_ClosedTemp_XML_name $var_ClosedTemp_XML_name_tmp
	mv $var_ClosedTemp_XML_name $var_ClosedTemp_XML_name".gz"
	gunzip -f $var_ClosedTemp_XML_name".gz"
}

#加密加压XML
HW_AfterOpt_xml()
{
	#encrypt var_default_ctree
	gzip -f $var_ClosedTemp_XML_name
	mv $var_ClosedTemp_XML_name".gz" $var_ClosedTemp_XML_name
	$var_pack_temp_dir/aescrypt2 0 $var_ClosedTemp_XML_name $var_ClosedTemp_XML_name_tmp
}

HW_SetAccessEquipNode()
{
	var_equipadmin_access_path=InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess
	var_access_value=0
	var_access_temp=""
	
	HW_PrevOpt_xml
	cfgtool get $var_ClosedTemp_XML_name $var_equipadmin_access_path EquipAdminAccess $var_access_temp
	if [ 0 -ne $? ]
	then
	    #get fail,add
	    cfgtool add $var_ClosedTemp_XML_name $var_equipadmin_access_path EquipAdminAccess $var_access_value
	fi
	
	#add fail,return fail
	if [ 0 -ne $? ]
	then
	    echo "ERROR::set EquipAdminAccess fail"
	    HW_AfterOpt_xml
	    return 1;
	fi
	
	#get success,set
	cfgtool set $var_ClosedTemp_XML_name $var_equipadmin_access_path EquipAdminAccess $var_access_value
	if [ 0 -ne $? ]
	then
	    echo "ERROR::Failed to set EquipAdminAccess!"
	    HW_AfterOpt_xml
	    return 1;
	fi

	HW_AfterOpt_xml
	return 0;
}

#解压/mnt/jffs2/customize_xml.tar.gz,获取操作XML
HW_StartCheckIsColsed()
{
	if [ -f $var_customize_xml_tar ]; then
		mkdir $var_ClosedTemp_dir
		tar -xzf $var_customize_xml_tar -C $var_ClosedTemp_dir
		if [ 0 -ne $? ]
		then
		    echo "ERROR::Failed to set EquipAdminAccess!"
		    return 1;
		fi
		cd $var_ClosedTemp_dir/customize_xml
		
		find . -type f -maxdepth 1|grep -v "\.\/\." |cut -d / -f2 |sort > $var_ClosedTemp_dir/files_name.txt
		read var_OptFileName < $var_ClosedTemp_dir/files_name.txt
		
		#mv to temp
		mv $var_ClosedTemp_dir/customize_xml/$var_OptFileName $var_ClosedTemp_XML_name
		
		#set node
		HW_SetAccessEquipNode
		
		#restore file
		rm -rf $var_ClosedTemp_dir/customize_xml/$var_OptFileName
		mv $var_ClosedTemp_XML_name $var_ClosedTemp_dir/customize_xml/$var_OptFileName
		
		#restore tar
		tar -czf $var_customize_xml_tmp_tar  customize_xml -C $var_ClosedTemp_dir
		mv $var_customize_xml_tmp_tar $var_customize_xml_tar
		rm -rf $var_ClosedTemp_dir
	else
		echo "ERROR::$var_customize_xml_tar is not exist!"
		return 1;
	fi
}

HW_CloseEquipAdmin()
{
	if [ -f $var_program_key_file ]; then
		grep -i "CHINA" -q $var_program_key_file
		if [ $? == 0 ];then
		return 0;
		fi
		
		grep -i "E8C" -q $var_program_key_file
		if [ $? == 0 ];then
		return 0;
		fi
		
		#not find CHINA or E8C,close equipadmin
		HW_StartCheckIsColsed
	else
		echo "ERROR::$var_program_key_file is not exist!"
		return 0;
	fi
	
	return
}

HW_CloseEquipAdmin
[ ! $? == 0 ] && exit 1
