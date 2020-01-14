#! /bin/sh

# �����������
var_bin_ft_word=$(echo $1 | tr a-z A-Z)
var_ssid=$3
var_wpa=$4
var_input_para=$*
var_is_HGU=1
var_para_num=$#
var_customize_telmex=/mnt/jffs2/TelmexCusomizePara

# ȫ�ֵ��ļ�����
var_etc_default_ctree_file="/etc/wap/hw_default_ctree.xml"
var_jffs2_default_ctree_file="/mnt/jffs2/hw_default_ctree.xml"
var_jffs2_ctree_file="/mnt/jffs2/hw_ctree.xml"
var_jffs2_ctree_bak_file="/mnt/jffs2/hw_ctree_bak.xml"
var_jffs2_ctree_tmp_file="/mnt/jffs2/hw_ctree_tmp.xml"
var_jffs2_boardinfo_file="/mnt/jffs2/hw_boardinfo"
var_jffs2_boardinfo_temp="/mnt/jffs2/hw_boardinfo.temp"
var_jffs2_customize_txt_file="/mnt/jffs2/customize.txt"
var_telnet_flag="/mnt/jffs2/ProductLineMode"

# ��������
var_pack_temp_dir=/bin/

#�ж������������Ƿ����@�ַ�,var_cfg_ft_word �� var_cfgfileword JSCT@8120���� var_cfg_ft_word=JSCT��cfgfileword=8120
#���������뵽���豸�ļ�
echo $2 | grep @ > /dev/null	
if [ $? == 0 ]
then
	var_cfg_ft_word=`echo $2 | tr a-z A-Z | cut -d @ -f1 `
	var_typeword=`echo $2 | tr a-z A-Z | cut -d @ -f2 `
else
	var_cfg_ft_word=`echo $2 | tr a-z A-Z`
	var_typeword=""
fi 

var_cfg_ft_word1=$var_cfg_ft_word

var_cfg_ft_word_choose=$(echo $(echo $var_cfg_ft_word | cut -b -7) | tr a-z A-Z)

HW_Check_Boardinfo()
{
	if [ -f $var_jffs2_boardinfo_file ]; then
		return 0;
	else
		echo "ERROR::$var_jffs2_boardinfo_file is not exist!"
		return 1;
	fi		
}

# ͨ��cfgtool���ó��������ֺ����������֣����������װ����ԴУ����ɺ�ִ��
HW_Set_Feature_Word()
{
    #���������ֵ�IDΪ0x0000001a�����������ֵ�IDΪ0x0000001b,
    #����Ǹ�DM�Ĵ��뱣��һ�µģ���Ʒƽ̨����ǿ��ϣ������������
   
    #�ж������������Ƿ���WIFI��β���������ɾ��
    var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`

	#�������Ԥ���ã����Ŷ���ΪE8C E8C����ͨ����ΪCOMMON UNICOM
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] ; then
		if [ "$var_bin_ft_word" = "E8C" ] ; then
		    var_cfg_ft_word_temp="E8C"
		fi
		if [ "$var_bin_ft_word" = "CMCC" ];then
			var_cfg_ft_word_temp="CMCC"
		fi
		
		if [ "$var_cfg_ft_word" = "CHOOSE_UNICOMBRI" ];then
			var_cfg_ft_word_temp="UNICOMBRI"
		fi
	fi
		
    #���boardinfo�Ƿ����
    HW_Check_Boardinfo
	if [ ! $? == 0 ]
	then
		echo "ERROR::Failed to Check Boardinfo!"
		return 1
	fi

	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001a\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001a\" ; obj.value = \"'$var_bin_ft_word'\"/g' -i
		
	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x0000001b\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x0000001b\" ; obj.value = \"'$var_cfg_ft_word_temp'\"/g' -i
	
	#������������ֺ����������ֵ��ļ�/mnt/jffs2/customize.txt��getcustomize.sh������ļ��ж�ȡ��Ϊ�˱�֤boardinfo�ܹ���ȫд�룬��Ҫ���������
   	echo $var_bin_ft_word $var_cfg_ft_word > $var_jffs2_customize_txt_file
}
   
#����typeword�ֶ�
HW_Customize_Set_CFGTypeFile()
{
    #�������м�飬�ٴβ����boardinfo�Ƿ����
	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000035\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000035\" ; obj.value = \"'$1'\"/g' -i
	return 0
}

#����cfg fileword
HW_Set_CfgFile_Word()
{
	if [ -z "$var_typeword" ]
	then   
		HW_Customize_Set_CFGTypeFile ""
		#����typeword��ɾȥtypeword�ļ���֮ǰ���Ƶ�typeword��
		rm -f /mnt/jffs2/typeword
	else
		HW_Customize_Set_CFGTypeFile "$var_typeword"
	fi
	return 0
}

# �������
HW_Customize_Check_Arg()
{
	if [ -z "$var_bin_ft_word" ] || [ -z "$var_cfg_ft_word" ]
	then
	    echo "ERROR::The binfeature word and cfgword should not be null!"
	    return 1
	fi
	
	return 0
}

# �����COMMON_WIFI ~COMMON���ƣ���BinWord��COMMON_WIFI->COMMON����Ȼ�߶�������
# ���CfgWord��wifi��β����ȥ��"wifi"�ַ���
HW_Change_Customize_Parameter()
{
	if [ "$var_bin_ft_word" = "COMMON_WIFI" ] ; then
	{
		var_bin_ft_word="COMMON"
	}
	fi
	
	#�ж������������Ƿ���WIFI��β���������ɾ��
	var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/WIFI$//g'`

	shift 2

	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"

	return 0
}

# ���CfgWord��ȥ��_SIP����_H248�ַ�
HW_Change_Customize_ParameterForVspa()
{
    #���������������û��_SIP����_H248��ֱ�ӷ��أ�����ʾ
    echo $var_cfg_ft_word | grep -iE "_SIP|_H248" > /dev/null	
	if [ ! $? == 0 ]
	then
	    return 0
	fi 
	
	#ɾ��������������ȥ��'_'���ַ��������¹������ò�������ΪCustomize����Ĳ���
    var_cfg_ft_word_temp=`echo "$var_cfg_ft_word" | sed 's/_.*//g'`
	shift 2  #����������ƶ�2��
	var_input_para="$var_bin_ft_word ""$var_cfg_ft_word_temp ""$*"
	return 0
}

#����CHOOSE�ֶ�
HW_Customize_Set_Choose()
{
    #�������м�飬�ٴβ����boardinfo�Ƿ����
	echo $var_jffs2_boardinfo_file | xargs sed 's/obj.id = \"0x00000031\" ; obj.value = \"[a-zA-Z0-9_]*\"/obj.id = \"0x00000031\" ; obj.value = \"'$1'\"/g' -i
	return 0
}

# ��Դ���
HW_Customize_Check_Resource()
{
        #HGU��Ҫ��ע��Ԥ���ö���,��Ҫ�漰CHOOSE_WORD�ֶ��޸ģ�SFU�����ֱ�Ӵ���
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] || [ "$var_cfg_ft_word" = "UNICOM" ] || [ "$var_cfg_ft_word" = "CMCC" ] || [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] || [ "$var_cfg_ft_word" = "CMCCWIFI" ]; then
		shift 2
		if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
			var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
		elif [ "$var_cfg_ft_word" = "CMCCWIFI" ]; then
			var_input_para="$var_bin_ft_word ""CHOOSE_CMCC ""$*"
		else
			if [ $var_is_HGU -eq 1 ] ; then
			var_input_para="$var_bin_ft_word ""CHOOSE_$var_cfg_ft_word1 ""$*"
			else
				var_input_para="$var_bin_ft_word ""$var_cfg_ft_word1 ""$*"
			fi
		fi
	fi
	
	#CR20141216011�ͺ��ǡ����籦ȷ���ˣ�telmex���ƻ���ʹ��TELMEX���������֣����ֲ��䣬���Ʋ���Ϊ9�������ü���ԭ����5����7������ʽ���£�
	#customize.sh COMMON TELMEX SSID WEP_KEY PPPoE_username PPPoE_password TR069�û��� TR069���� WEB���� CLI�û��� CLI����
	if [ $var_cfg_ft_word == "TELMEX" ] 
	then
		#����֮ǰ���Ѿ���5���������Ƶ��������������������¶��ƣ�Ҫɾ�����ļ��������Ƽ���ʧ�ܣ�
		if [ -f $var_customize_telmex ]
		then
			rm -rf $var_customize_telmex	
		fi
		# 7��������9���������涨��ʧ�ܣ�Ϊ����ʾװ��
		if [ 7 -eq $var_para_num ] || [ 9 -eq $var_para_num ]
		then 
			echo "ERROR::input para number is not enough!"
			return 1	
		fi
	fi
	
	# ����Customize���̽���װ����Դ��У��, ���ļ���ʱд��typeword ��ʱд��/mnt/jffs2/typeword �ļ��� �����ͨ���ļ����ݣ�ͨ��argv ����
	# ��Ҫ������չ�ĺ�����ʮ�����ң�����Customize APP ����Ҫ��չ�������ֶΡ�
	if [ -f /mnt/jffs2/typeword ]; then
		cp -f /mnt/jffs2/typeword /mnt/jffs2/typeword_bak	
	fi
	echo $var_typeword > /mnt/jffs2/typeword

	Customize $var_input_para
	
	var_result=$?
	
	if [ 0 -eq $var_result ] 
	then
		#дboardinfo���ļ�
		HW_Set_CfgFile_Word
		rm -f /mnt/jffs2/typeword_bak
	else
		#����ʧ��, ������ڱ����ļ�,��ԭ����
		if [ -f /mnt/jffs2/typeword_bak ]; then
			mv /mnt/jffs2/typeword_bak /mnt/jffs2/typeword
		else 
			#��һ�ζ���ʧ��
			rm -f /mnt/jffs2/typeword	
		fi	
	fi
	
	return 0
}

HW_Customize_Check_PCCWMacCheck()
{
	# �����PCCW����Ҫ����WLAN MAC��У��
	if [ "$var_cfg_ft_word" = "PCCW3MAC" ] || [ "$var_cfg_ft_word" = "PCCW3MACWIFI" ] \
	  || [ "$var_cfg_ft_word" = "PCCW4MAC" ] || [ "$var_cfg_ft_word" = "PCCW4MACWIFI" ]
	then
		pccwmaccheck $var_input_para
		var_pccwresult=$?
	else
		var_pccwresult=0
	fi
	
	return 0
}

#���ƴ���
HW_Customize_Delete_File()
{
	rm -f $var_telnet_flag
	return 0
}

# ������
HW_Customize_Print_Result()
{
	# ���ݲ�ͬ��ִ�н�������ز�ͬ�Ĵ�������
	if [ 0 -eq $var_result ]
	then
	    #pccw3mac pccw4mac�����������wlanmac��У��
	    HW_Customize_Check_PCCWMacCheck $var_input_para
	    if [ 0 -eq $var_pccwresult ]
	    then
	    	HW_Set_Feature_Word
	    	if [ ! $? == 0 ]
	    	then
	    	    echo "ERROR::Failed to set Feature Word!"
		    return 1
		fi			
	    elif [ 1 -eq $var_pccwresult ]
	    then
		echo "ERROR::input para number is not enough!"
		return 1
	    elif [ 2 -eq $var_pccwresult ]
	    then
		echo "ERROR::SSIDMAC fail!"
		return 1
	    else
		echo "ERROR::customize fail!"
		return 1
	    fi
	    return 0
	elif [ 1 -eq $var_result ]
	then
	    echo "ERROR::input para number is not enough!"
	    return 1
	elif [ 2 -eq $var_result ]
	then
	    echo "ERROR::Updateflag file is not existed!"
	    return 1
	elif [ 3 -eq $var_result ]
	then
	    echo "ERROR::config tar file is not existed!"
	    return 1
	elif [ 4 -eq $var_result ]
	then
	    echo "ERROR::Null pointer!!"
	    return 1
	elif [ 5 -eq $var_result ]
	then
	    echo "ERROR::XML parse fail!!"
	    return 1
	elif [ 6 -eq $var_result ]
	then
	    echo "ERROR::XML get node or attribute fail!"
	    return 1
	elif [ 7 -eq $var_result ]
	then
	    echo "ERROR::XML get relation node fail!"
	    return 1
	elif [ 8 -eq $var_result ]
	then
	    echo "ERROR::Spec file is not existed!"
	    return 1
	elif [ 9 -eq $var_result ]
	then
	    echo "ERROR::Set bin word fail!"
	    return 1
	elif [ 10 -eq $var_result ]
	then
	    echo "ERROR::Set config word fail!"
	    return 1
	elif [ 11 -eq $var_result ]
	then
	    echo "ERROR::Uncompress tar fail!"
	    return 1
	elif [ 12 -eq $var_result ]
	then
	    echo "ERROR::Config file is not existed!"
	    return 1
	elif [ 13 -eq $var_result ]
	then
	    echo "ERROR::Recover file is ont existed!"
	    return 1
	elif [ 14 -eq $var_result ]
	then
	    echo "ERROR::Run script fail!"
	    return 1
	elif [ 15 -eq $var_result ]
	then
	    echo "ERROR::Create new recover config file fail!"
	    return 1
	elif [ 16 -eq $var_result ]
	then
	    echo "ERROR::Create old recover config file fail!"
	    return 1
	elif [ 17 -eq $var_result ]
	then
	    echo "ERROR::Copy spec default ctree fail!"
	    return 1
	elif [ 18 -eq $var_result ]
	then
	    echo "ERROR::Check Choose Res fail!"
	    return 1
	elif [ 19 -eq $var_result ]
	then
	    echo "ERROR::Resolver customize file fail!"
	    return 1
	else   
	    echo "ERROR::customize fail!"
		return 1
	fi

	return 0
}

#HGU��֧����Ԥ���ã��ڴ����ж�
HW_Customize_CheckIsHGU()
{
	cat /proc/wap_proc/pd_static_attr | grep -w pdt_type | grep HGU > /dev/null
	if [ $? -eq 0 ] ; then
		return 1
	fi
	
	return 0
}

#echo /proc/pdt_proc/save_boardinfo to save boardinfo for add chooseid
echo "1" >  /proc/pdt_proc/save_boardinfo 

#������⣺����Ӧ�ð���BinWord&SpecWord
HW_Customize_Check_Arg
[ ! $? == 0 ] && exit 1

#��������
HW_Change_Customize_Parameter $var_input_para

#����������Ҫ�ǽ������������е�_SIP��_H248���й���
HW_Change_Customize_ParameterForVspa $var_input_para

#HGU�ſ�����Ԥ���ö��ƣ���Ԥ���ö��Ʋ��漰CHOOSE_WORD�Ĵ���
HW_Customize_CheckIsHGU
if [ $? -eq 0 ] ; then
	var_is_HGU=0
fi

#��Ԥ����ģʽ�����NOCHOOSE�ֶΣ�����ʼ��ΪCHOOSE_XXX
if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ] || [ "$var_cfg_ft_word" = "UNICOM" ] || [ "$var_cfg_ft_word" = "CMCC" ] || [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] || [ "$var_cfg_ft_word" = "CMCCWIFI" ]; then
{
	#HW_Customize_Add_Choose
	if [ "$var_cfg_ft_word_choose" = "CHOOSE_" ]; then
		HW_Customize_Set_Choose "$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "UNICOMBRIDGE" ] ; then
		HW_Customize_Set_Choose "CHOOSE_UNICOM"
	elif [ "$var_cfg_ft_word" = "CMCC" ] ; then
		HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
	elif [ "$var_cfg_ft_word" = "CMCCWIFI" ] ; then
		HW_Customize_Set_Choose "CHOOSE_CMCC"
	else
		#COMMON/UNICOM����ֻ��HGU֧����Ԥ����
		if [ $var_is_HGU -eq 1 ]; then
			HW_Customize_Set_Choose "CHOOSE_$var_cfg_ft_word"
		else
			HW_Customize_Set_Choose ""
		fi
	fi
}
else
{
	HW_Customize_Set_Choose ""
}
fi

HW_Customize_Check_Resource $var_input_para
[ ! $? == 0 ] && exit 1

# ������
HW_Customize_Print_Result $var_input_para
[ ! $? == 0 ] && exit 1

#���ƴ���
HW_Customize_Delete_File

sync
echo "success!" && exit 0


