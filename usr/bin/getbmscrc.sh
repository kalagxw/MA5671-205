#/bin/sh

prevcrcfile="/mnt/jffs2/prevcrc"
oldcrcfile="/mnt/jffs2/oldcrc"

if [ 0 -ne $# ]; then
    echo "ERROR::input para is not right!";
    return 1;
else
    echo "prevcrc:"
    if [ -f $prevcrcfile ]; then
        hexdump $prevcrcfile
    else
        echo "no prevcrc file!"
    fi

    echo "oldcrc:"
    if [ -f $oldcrcfile ]; then
        hexdump $oldcrcfile
    else
        echo "no oldcrc file!"
    fi
	
    return 0;
fi