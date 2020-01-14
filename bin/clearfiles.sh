#!/bin/sh

CheckFilePath()
{
    path=$1
    echo $1 | grep '\.\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '/\.' > /dev/null
	if [ 0 == $? ]
	then
        return 1;	
	fi
	
	echo $1 | grep '\./' > /dev/null
	if [ 0 == $? ]
	then
        return 1;		
	fi
    
	return 0;
}

if [ 1 -ne $# ]; 
then
    echo "ERROR::input para is not right!"
    return 1;
else
	CheckFilePath $1
	if [ 0 -ne $? ]
	then
        echo "ERROR::input para is not right!"
        return 1;		
	fi
	
	case "$1" in
	 */jffs2/prevcrc | */jffs2/oldcrc | */jffs2/oltoldcrc | */jffs2/oltprevcrc | */jffs2/hw_bms_prev.xml | */jffs2/hw_osk_voip_prev.xml | */jffs2/panicinfo  )  rm $1;;
	 * ) echo "ERROR::input para is not right!"; return 1;;
	esac

	return $?
fi
