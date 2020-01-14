#! /bin/sh

FILE_BOARTYPE=/mnt/jffs2/board_type
FILE_BOARDTYPE_CLASS=/var/productclass.cfg

GetSupportType()
{
	var_board_name=""
	if [ -f $FILE_BOARDTYPE_CLASS ]
	then 
		while read line;
		do
			board_type=`echo $line | sed 's/product="\(.*\)";\(.*\)/\1/g'`
			var_board_name=$var_board_name" "$board_type
		done < $FILE_BOARDTYPE_CLASS
	fi
	echo "support boardtype:" 
	echo "   "$var_board_name
}

PrintHelp()
{
	echo "boardtype.sh Usage:"
	echo "    -s to set custom boardtype."
	echo "    -g to get custom boardtype."
	echo "    -c to clean custom boardtype."
	echo "Example:"
	echo "    boardtype.sh -s HG8240R"
	echo "    boardtype.sh -g"
	echo "    boardtype.sh -c"
	GetSupportType
}

var_boardtype=0
var_boardid=0
var_pcbid=0

GetTypeByName_5115()
{		
    case $1  in	
	#5115S系列HG8310，HG8010C，HG8311，HG8110C,HG8310M,HG8010a
	HG8310 )
		var_boardtype=2013			
		;;
	HG8310M )
		var_boardtype=1011			
		;;
	HG8010a )
		var_boardtype=2011
		;;
	HG8010C )
		var_boardtype=1022
		
		;;
	HG8311 )
		var_boardtype=2031
		;;
	HG8110F )
		var_boardtype=2032
		;;	
		
	#5115H系列HG8346R，HG8245C，HG8120F，HG8321R，HG8321，HG8120C，HG8240F，HG8342R，HG8342，HG8240C,HG8346M,HG8342M
	HG8346R )
		var_boardtype=3011
		if [ "$var_boardid" = "13" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3131
		fi
		;;
	HG8245C )
		var_boardtype=3012
		if [ "$var_boardid" = "1" -a "$var_pcbid" = "0" ];then
		      var_boardtype=3061
		fi		   
		if [ "$var_boardid" = "6" ];then
		      var_boardtype=3061
		fi
		;;
	HG8321 )
		var_boardtype=3023
		;;
	HG8120C )
		var_boardtype=3024		
		if [ "$var_boardid" = "15" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3151
		fi
		;;
	HG8120A )
		var_boardtype=3025
		;;
	HG8120F )
		var_boardtype=3026
		;;			
	HG8240F )
		var_boardtype=3031
		;;
	HG8342R )
		var_boardtype=3032
		;;
	HG8342 )
		var_boardtype=3033
		;;
	HG8240C )
		var_boardtype=3034
		;;
	HG8346M )
		var_boardtype=3013
		if [ "$var_boardid" = "13" -a "$var_pcbid" = "4" ];then
		      var_boardtype=3132
		fi
		;;
	HG8342M )
		var_boardtype=3035
		;;
	HG8340 )
		var_boardtype=3052
		;;
	HG8340M )
		var_boardtype=3053
		;;
	HG8345R )
		var_boardtype=3001
		;;		
	HG8326R )
		var_boardtype=3071
		;;
		
  #5115T系列HG8240T  HG8045D	HG8245C2 HG8247H
	HG8240T )
		var_boardtype=4091
		;;
	HG8045D )
		var_boardtype=4331
		;;	
  	HG8245C2 )
		var_boardtype=4061
		;;
	HG8247H )
		var_boardtype=4011
		;;			
	* )
		var_boardtype=0
		;;
	esac

	return $var_boardtype
}


GetTypeByName_5116()
{
	case $1  in	
	
	#5116S系列HG8010H HG8010C HG8310 HG8310M	
	HG8010C )		
		if [ "$var_boardid" = "1" ];then
		    var_boardtype=5011
		fi		   
		if [ "$var_boardid" = "2" ];then
		    var_boardtype=5021
		fi		
		;;
	HG8310  )
		if [ "$var_boardid" = "1" ];then
		    var_boardtype=5012
		fi		   
	        if [ "$var_boardid" = "2" ];then
		    var_boardtype=5022
		fi		
		;;
	HG8310M )
		 if [ "$var_boardid" = "1" ];then
		      var_boardtype=5013
		 fi		   
		 if [ "$var_boardid" = "2" ];then
		      var_boardtype=5023
		 fi
		;;
	HG8510 )	
		if [ "$var_boardid" = "1" ];then
		      var_boardtype=5014
		 fi		   
		 if [ "$var_boardid" = "2" ];then
		      var_boardtype=5024
		 fi
		;;
	#5116L系列HG8110H	
	HG8110H )		
		var_boardtype=6011
		;;
	HG8110F )		
		var_boardtype=6012
		;;
	HG8120F )		
		var_boardtype=6021
		;;
	HG8521 )		
		var_boardtype=6022
		;;	
		
	#5116H系列HG8346R HG8346M HG8245A HG8342R HG8342M HG8345R HG8045A	
	HG8346R )		
		var_boardtype=7031
		;;
	HG8346M )		
		var_boardtype=7032
		;;
	HG8342M )		
		var_boardtype=7041
		;;
	HG8542 )		
		var_boardtype=7042
		;;
	HG8240F )		
		var_boardtype=7043
		;;
	HG8345R )		
		var_boardtype=7051
		;;
	HG8540 )		
		var_boardtype=7061
		;;
	HG8040F )		
		var_boardtype=7062
		;;
	HG8121C )		
		var_boardtype=7081
		;;
	HG8145A )		
		var_boardtype=7131
		;;		
	esac

	return $var_boardtype
}

GetTypeByName()
{
	if [ -e /var/SD5116H.txt -o -e /var/SD5116S.txt -o -e /var/SD5116L.txt -o -e /var/SD5116T.txt ]
	then
		    GetTypeByName_5116 $1
	else
		GetTypeByName_5115 $1
	fi
		
	return $var_boardtype
}

EchoNameByBoardtype_5115()
{
	case $1  in
		
	#5115S系列HG8310，HG8010C，HG8311，HG8110C,HG8310M,HG8010a
	2013 )
		var_boardname=HG8310
		;;
	1021 )
		var_boardname=HG8310
		;;
	1011 )
		var_boardname=HG8310M
		;;
	2011 )
		var_boardname=HG8010a
		;;
	1022 )
		var_boardname=HG8010C
		;;
	2031 )
		var_boardname=HG8311
		;;
	2032 )
		var_boardname=HG8110F
		;;
	
	2012 )
		var_boardname=HG8010
		;;
		
	#5115H系列HG8346R，HG8245C，HG8120F，HG8321R，HG8321，HG8120C，HG8240F，HG8342R，HG8342，HG8240C,HG8346M,HG8342M
	3011 )
		var_boardname=HG8346R
		;;
	3012 )
		var_boardname=HG8245C
		;;
	3025 )
		var_boardname=HG8120A
		;;
	3023 )
		var_boardname=HG8321
		;;
	3024 )
		var_boardname=HG8120C
		;;
	3026 )
		var_boardname=HG8120F
		;;		
	3031 )
		var_boardname=HG8240F
		;;
	3032 )
		var_boardname=HG8342R
		;;
	3033 )
		var_boardname=HG8342
		;;
	3034 )
		var_boardname=HG8240C
		;;
	3013 )
		var_boardname=HG8346M
		;;
	3035 )
		var_boardname=HG8342M
		;;
	3052 )
		var_boardname=HG8340
		;;
	3053 )
		var_boardname=HG8340M
		;;		
	3061 )
		var_boardname=HG8245C
		;;
	
	3001 )
		var_boardname=HG8345R
		;;		
	3071 )
		var_boardname=HG8326R
		;;		
	3131 )
		var_boardname=HG8346R
		;;		
	3132 )
		var_boardname=HG8346M
		;;
	3151 )
		var_boardname=HG8120C
		;;
		
	#5115T系列HG8245C2 HG8240T HG8045D HG8247H
	4011 )
		var_boardname=HG8247H
		;;
	4061 )
		var_boardname=HG8245C2
		;;
	4091 )
		var_boardname=HG8240T
		;;
	4331 )
		var_boardname=HG8045D
		;;				
	* )
		var_boardname=unknown
		;;
	esac

	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype_5116()
{
	case $1  in	
		
	#5116S系列HG8010C HG8310 HG8310M
	5011 )
		var_boardname=HG8010C
		;;
	5021 )
		var_boardname=HG8010C
		;;
	5012 )
		var_boardname=HG8310
		;;
	5022 )
		var_boardname=HG8310
		;;
	5013 )
		var_boardname=HG8310M
		;;
	5023 )
		var_boardname=HG8310M
		;;
	5014 )
		var_boardname=HG8510
		;;
	5024 )
		var_boardname=HG8510
		;;		
		
	#5116L系列HG8110H	
	6011 )		
		var_boardname=HG8110H
		;;
	6012 )		
		var_boardname=HG8110F
		;;
	6021 )		
		var_boardname=HG8120F
		;;
	6022 )		
		var_boardname=HG8521
		;;	
		
	#5116H系列HG8346R HG8346M HG8245A HG8342M HG8345R
	7031 )		
		var_boardname=HG8346R
		;;	
	7032 )		
		var_boardname=HG8346M
		;;
	7041 )		
		var_boardname=HG8342M
		;;
	7042 )		
		var_boardname=HG8542
		;;
	7043 )		
		var_boardname=HG8240F
		;;
	7051 )		
		var_boardname=HG8345R
		;;
	7061 )		
		var_boardname=HG8540
		;;
	7062 )		
		var_boardname=HG8040F
		;;
	7081 )		
		var_boardname=HG8121C
		;;
	7131 )		
		var_boardname=HG8145A
		;;	
			
	* )
		var_boardname=unknown
		;;
	esac

	echo "custom board name is $var_boardname"
}

EchoNameByBoardtype()
{
	if [ -e /var/SD5116H.txt -o -e /var/SD5116S.txt -o -e /var/SD5116L.txt -o -e /var/SD5116T.txt ]
		then
		    EchoNameByBoardtype_5116 $1
	else
		EchoNameByBoardtype_5115 $1
	fi

}

var_cmd=$1

case $1  in
	-s )
		if [ $# -ne 2 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		var_boardid=`cat /var/board_version | grep board_id | grep -oE [0-9]*`
		var_pcbid=`cat /var/board_version | grep pcb_id | grep -oE [0-9]*`
		
		GetTypeByName $2
		if [ $var_boardtype -eq 0 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi

		#标定校验
		if [ -f $FILE_BOARDTYPE_CLASS ]
		then
			var_flag=`cat $FILE_BOARDTYPE_CLASS | grep \"$var_boardtype\"`
			if [ -z "$var_flag" ]
			then
				echo "cannot board to type $2!" && exit 0
			else
				echo "$var_boardtype" > $FILE_BOARTYPE
				sync
				echo "success!" && exit 0
			fi
		else
			echo "cannot board to type $2!" && exit 0
		fi
		;;
	-g )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		
	    if [ -f $FILE_BOARTYPE ] ; then
			EchoNameByBoardtype "$(cat $FILE_BOARTYPE)" && exit 0
		else
			echo "ERROR::no custom board name!" && exit 0
		fi	
		;;
	-c )
		if [ $# -ne 1 ] ; then
			echo "ERROR::input para is not right!" && exit 1
		fi
		
		rm -f $FILE_BOARTYPE
		sync
		echo "success!" && exit 0
		;;
	-h )
	        PrintHelp && exit 0
		;;	
	* )
		echo "ERROR::input para is not right!"
		exit 1
		;;
	esac
