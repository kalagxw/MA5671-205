#! /bin/sh

if [ $# -ne 1 ];then
	echo "ERROR::input para is not right!";
	echo "fail!"
elif [ "$1" = "2" ];then
	echo 1 > /mnt/jffs2/doublecore
	echo "set double core ok!"
	echo "success!"
elif [ "$1" = "1" ];then
   	echo 0 > /mnt/jffs2/doublecore
   	echo "set single core ok!"
	echo "success!"
else
    echo "ERROR::input para is not right!"
	echo "fail!"
fi

exit 1

