#! /bin/sh

#get CTCOM or Union spec parameters
#include: custom information

#for custom information
customexist=0
oversion=""
cinfo=""

ctree_ram="/var/hw_ctree.xml"
ctree="/mnt/jffs2/hw_ctree.xml"
defaultctree="/mnt/jffs2/customize_xml/hw_default_ctree.xml"
defaultctreegz="/var/hw_ctree.xml.gz"
var_pack_temp_dir=/bin/
temp_default_ctree="/var/hw_aestemp_default_ctree.xml"

error_flag=0
tmp_value=""

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    exit 1;
fi

#for function get_attribute_value
##function - get the attribute value
#$1:ctree name, $2:node name, $3:attribute name
get_attribute_value()
{	  
  cfgtool gettofile $1 $2 $3
  if [ 0 -ne $? ]
  then
  	echo "ERROR::Fail to get $3 value!"
  	return 1
  else
  	read tmp_value < /var/cfgtool_ret
  	if [ 0 -ne $? ]
  	then 
  		echo "ERROR::Failed to read $3 value!"
  		rm -f /var/cfgtool_ret
  		return 1
  	fi
  fi
  	
  rm -f /var/cfgtool_ret
  return 0
}

if [ -f $defaultctree ]
then 
	cp -f $defaultctree $ctree_ram
else
	cp -f $ctree $ctree_ram
fi
	
$var_pack_temp_dir/aescrypt2 1 $ctree_ram $temp_default_ctree
mv $ctree_ram $defaultctreegz
gunzip -f $defaultctreegz

if [ 0 -ne $? ]
then
	mv $defaultctreegz $ctree_ram
fi

cinfo=`cat $ctree_ram | grep -o customInfo=\"[a-zA-Z0-9_]*\" | cut -d "\"" -f 2`
oversion=`cat $ctree_ram | grep -o originalVersion=\"[a-zA-Z0-9_]*\" | cut -d "\"" -f 2`

if [ 0 -ne $error_flag ]; then
	echo "ERROR::Fail to get NodeInfo!"
	exit 1
fi	

rm -f $ctree_ram

##print the custom information
echo "originalVersion   =" "$oversion"
echo "customInfo        =" "$cinfo"
echo ""	
echo "success!"

exit 0
