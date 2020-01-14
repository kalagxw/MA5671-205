#/bin/sh

#console_pid=`pidof telnet 127.0.0.1`

if [ -n "$WAP_SHELL" ]
then
    echo "WAP mode is running,do not start it again!Type 'exit' to return WAP mode."
    return 1
fi


sleep 3

echo "Press any key to get started"
read -n1 name

port=23
ctree="/mnt/jffs2/hw_ctree.xml"
ctreeuse="/var/hw_ctreeuse.xml"
ctreeusegz="/var/hw_ctreeuse.xml.gz"
temp_ctree="/var/hw_aes_temp_ctree.xml"
var_pack_temp_dir=/bin/
tmp_value=""

#  function - get the attribute value
#  $1:ctree name, $2:node name, $3:attribute name
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
}


#get custom information
#1.decrypt 2.gunzip

cp -f $ctree $ctreeuse
$var_pack_temp_dir/aescrypt2 1 $ctreeuse  $temp_ctree
mv $ctreeuse   $ctreeusegz
	
#小系统切换过来的代码是直接加密的，压缩函数是假的，没有真正压缩
gunzip -f $ctreeusegz
if [ 0 -ne $? ]
then
mv $ctreeusegz $ctreeuse
fi	

get_attribute_value $ctreeuse InternetGatewayDevice.UserInterface.X_HW_CLITelnetAccess TelnetPort
port=$tmp_value

rm -f $ctreeuse 

echo "telnet port:$port"

telnet 127.0.0.1 $port
