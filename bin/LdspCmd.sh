#!/bin/sh

paranum=$#

send_hlp()
{
	sndhlp $@ >>/dev/null
	result=$?
	if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	fi
	
	return $result
}

send_hlp_print_log()
{
	sndhlp $@
	result=$?
	if [ "$result" != "0" ];then
	    echo "ERROR::input para is not right!"
	fi
	
	return $result
}

check_param()
{
	if [ "$paranum" != "$1" ];then
	  echo "ERROR::input para is not right!"
		return 1
	fi
	return 0
}

ishex()
{
	result=0
	case $1 in
	[0-f])
		result=1
		;;
	[0-f][0-f])
		result=1
		;;
	esac
	return $result
}

clearall()
{
   echo " clearall "

}

help_ploam()
{
		echo "         ploam"
		echo "                 -h  --- Get help of ploam Module"
		echo "                 print on  --- Open the printed switch of PLOAM messages" 
		echo "                 print off --- Close the printed switch of PLOAM messages"  
		echo "                 alarm on  --- Open the printed switch of PLOAM alarm messages"
		echo "                 alarm off  --- Close the printed switch of PLOAM alarm messages"
		echo "                 err on  --- Open the printed switch of PLOAM err messages" 
		echo "                 err off  --- Close the printed switch of PLOAM err messages"
		echo "                 omci on  --- Open the printed switch of OMCI messages"
		echo "                 omci off --- Close the printed switch of OMCI messages"
		echo "                 stat  --- get statistics of PLOAM messages" 
		echo "                 clear stat  --- Clear statistics of PLOAM messages" 
		echo "                 bwmap  --- Get BWMAP info" 
		echo ""
}

help_optic()
{
		echo "         optic"
		echo "                 -h  --- Get help of optic Module"
		echo "                 display reg --- Get the value of optic register"
		echo ""
}

help_led()
{
		echo "         led"
		echo "                 -h  --- Get help of led Module"
		echo "                 display status [ledid] [ledcolor] --- display led status"
		echo ""
}


help_gpio()
{
		echo "         gpio"
		echo "                 -h  --- Get help of gpio Module"
		echo "                 display value [gpio]  ---Get value of gpio"
		echo ""
}

help_i2c()
{
		echo "         i2c"
		echo "                 -h  --- Get help of I2C Module"
		echo "                 read A0/A2 [addr] --- Get the value of A0/A2 register" 
		echo "                                       the "addr" expressed by hexadecimal represents the address of regiser,such as echo "6e"(don't use the "0x" before)"
		echo ""
}

help_usb()
{
		echo "         usb"
		echo "                 -h  --- Get help of USB Module"
		echo "                 display status --- Get the status of USB module"
		echo ""
}


help_codec()
{
		echo "         codec"
		echo "                 -h  --- Get help of Codec Module"
		echo "                 display global info [portid]     ---display the info of CODEC Module ,portid[0-3]"
		echo ""
}

help_phy()
{
		echo "         phy"
		echo "                 -h  --- Get help of Phy Module"
		echo "                 display debug info ---Get all phy register informations of ports"
		echo ""
}

help_mpcp()
{
		echo "         mpcp"
		echo "                 switch on/off --- Open/Close the switch of MPCP"
		echo "                 display statistics --- Get statistics of MPCP"
		echo ""
}

help_wifi()
{
		echo "         wifi"
		echo "                 -h                                                        --- Get help of Wifi Module"
		                                                                                 
		echo "                 statistic [ssid index]                                    ---display the statistics of ssid, index[1-8] "
		echo "                 statistic clear [ssid index]                              ---clear the statistics of ssid, index[1-8] "
		echo "                 config [ssid index]                                       ---display the config of ssid, index[1-8] "
		echo "                 status common [ssid index]                                ---display the common status of ssid, index[1-8] "		
		echo "                 status sta [ssid index] <mac value>                       ---display the assoclist sta info, index[1-8] "
		echo "                 status network [band value]                               ---display the network status of band, value[a|b] "
		echo "                 status channel                                            ---display the change history of channel "
		echo "                 status connection                                         ---display the sta connection "	
		echo "                 debug scan [band value] <enable|disable>                  ---enable/disalbe the acsd debug switch, value[a|b] "	
		echo "                 debug scan [band value] ap start                          ---scan the neigborhood ap info , value[a|b] "	
		echo "                 debug scan [band Value ] channel start                    ---scan the channel info , value[a|b] "
		echo "                 debug wps <enable|disable>                                ---enable/disalbe the wps debug switch "	
		echo "                 debug auth <enable|disable>                               ---enable/disalbe the auth debug switch "		
		echo "                 debug adapter <enable|disable>                            ---enable/disalbe the adapter of wifi debug switch "		
		echo "                 debug unicastrate [band value] <rate>                     ---set the nrate, value[a|b] "	
		echo "                 debug multicastrate [band value] <rate>                   ---set the mrate, value[a|b] "	
		echo "                 debug interference  [band value] <mode>                   ---set the interference, value[a|b], mode[0-4] "
		echo "                 debug frameburst [band value] <enable|disable>            ---enable/disalbe frameburst, value[a|b] "	
		echo "                 debug ampdu  [band value] <enable|disable>                ---enable/disalbe the ampdu, value[a|b] "
		echo "                 debug ampdu_tid  <tid> [band value] <enable|disable>      ---enable/disalbe the ampdu_tid, tid[0-7] value[a|b] "		
		echo ""
}

help_other()
{
		echo "         clear --- Clear statistics of Soc"
		echo "         clearall --- Clear all the statistics"
		echo "         mod print [module_name] [level] [0/1] --- Open the switch of specified module and level,level[0-3]"
		echo "         print on --- Open the printed switch of syslog"
		echo "         print off --- Close the printed switch of syslog"
		echo ""
}

ATCMDS="^SYSINFO ^SYSINFOEX ^DIALMODE +CGACT +CGDCONT +COPS ^NDISDUP ^NDISSTATQRY ^DHCP +CGMI +CGMM +CGMR ^HWVER ^SN +CGSN +CSQLVLEXT ^SYSCFGEX +CLCK +CPWD +CPIN ^CPIN"
ATACTION="excution test"
parase_datacard_atcmd()
{
    cmd=0	
	  index=1	
	  for atcmd in $ATCMDS
	  do
	      [[ "$1" == "$atcmd" ]]&&cmd=$index&&break			
        let "index += 1"
    done	
	  return 0
}

parase_datacard_act()
{
    act=0	
	  index=1	
	  for action in $ATACTION
	  do
	      [[ "$1" == "$action" ]]&&act=$index&&break			
        let "index += 1"
    done	
	  return 0
}

help_datacard_atcmd()
{
    echo "datacard atcmd:"
	  echo ""
    index=1	
	  for atcmd in $ATCMDS
	  do
	     echo -n "$index     $atcmd"	
       echo ""		
       echo ""				
       let "index += 1"
    done
	  return 0
}

help_datacard_act()
{
    echo "datacard atcmd action:"
	  echo ""
    index=1	
	  for action in $ATACTION 
	  do
	    echo -n "$index     $action"	    
	    echo ""
		  echo ""		
      let "index += 1"
    done
	  return 0
}

help_datacard()
{
		echo "         datacard"
		echo "                 -h  --- Get help of datacard Module"
		echo "                 debug show --- show datacard module state" 
		echo "                 debug timer on --- start datacard module timer" 
		echo "                 debug timer off --- stop datacard module timer"  
		echo "                 debug atcmd act --- atcmd debug" 
		echo ""
} 
	if [ "$1" = "-h" ];then
		check_param 1 || exit $?
		echo "Usage:[module] [command] [option]"
		help_ploam
		help_optic
		help_led
		help_gpio
		help_i2c
		help_usb
		help_phy
		help_mpcp
		help_codec
		help_wifi
		help_other
		help_datacard
		exit 0
		
	elif [ "$1" = "clear" ];then
		check_param 1 || exit $?
#		send_hlp 0 0x2000160f 15 0 || exit $?
		
	elif [ "$1" = "clearall" ];then
#		check_param 1 || exit $?
#		clearall || exit $?
                exit 1
					
	elif [ "$1" = "ploam" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_ploam
			exit 0
		
		elif [ "$2" = "print" ];then
			check_param 3 || exit $?
			if [ "$3" = "on" ];then
				send_hlp 0 0x2000300b 0xb 8 0 1 || exit $?
			elif [ "$3" = "off" ];then
				send_hlp 0 0x2000300b 0xb 8 0 0 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi 

		elif [ "$2" = "alarm" ];then
			check_param 3 || exit $?
			if [ "$3" = "on" ];then
				send_hlp 0 0x2000300b 0xb 8 1 1 || exit $?
			elif [ "$3" = "off" ];then
				send_hlp 0 0x2000300b 0xb 8 1 0 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1			
			fi 

		elif [ "$2" = "err" ];then
			check_param 3 || exit $?
			if [ "$3" = "on" ];then
				send_hlp 0 0x2000300b 0xb 8 2 1 || exit $?
			elif [ "$3" = "off" ];then
				send_hlp 0 0x2000300b 0xb 8 2 0 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1			
			fi 

		elif [ "$2" = "omci" ];then
			check_param 3 || exit $?
			if [ "$3" = "on" ];then
				send_hlp 0 0x2000300b 0xb 8 3 1 || exit $?
			elif [ "$3" = "off" ];then
				send_hlp 0 0x2000300b 0xb 8 3 0 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1				
			fi 

		elif [ "$2" = "stat" ];then
			check_param 2 || exit $?
			send_hlp 0 0x2000300e 0xe 4 1 || exit $?

		elif [ "$2" = "clear" ];then
			check_param 3 || exit $?
			if [ "$3" = "stat" ];then
				send_hlp 0 0x2000300d 0xd 4 1 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1					
			fi

		elif [ "$2" = "bwmap" ];then
			check_param 2 || exit $?
			send_hlp 0 0x2000300c 0xc 0 0 || exit $?
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
		
  elif [ "$1" = "datacard" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_datacard
			exit 0
		
		elif [ "$2" = "debug" ];then		  
		  if [ "$3" = "-h" ];then
		     check_param 3 || exit $?
		     help_datacard_atcmd
		     help_datacard_act
		  elif [ "$3" = "show" ];then
		     check_param 3 || exit $?
         sndhlp  0 0x20017011 0x11 12 0 0 0
		  elif [ "$3" = "timer" ];then
		     if [ "$4" = "on" ];then
		        check_param 4 || exit $?
		     		sndhlp  0 0x20017011 0x11 12 1 0 0
		     elif [ "$4" = "off" ];then
		        check_param 4 || exit $?
		        sndhlp  0 0x20017011 0x11 12 2 0 0
		     else
						echo "ERROR::input para is not right!"
						exit 1
		     fi
		  else
		  	 check_param 4 || exit $?
		     parase_datacard_atcmd $3
		     parase_datacard_act $4
		     echo -n "cmd = $cmd"
		     echo ""
		     echo -n "act = $act"
		     echo ""
		     sndhlp  0 0x20017011 0x11 12 3 $cmd $act
		  fi
	  else
			echo "ERROR::input para is not right!"
			exit 1
	  fi
		     
	elif [ "$1" = "optic" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_optic
			exit 0
		
		elif [ "$2" = "display" ];then
			check_param 3 || exit $?
			if [ "$3" = "reg" ];then
				send_hlp 0 0x20005009 0x9 20 1 0 0 0 0x70  || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1					
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi

	elif [ "$1" = "led" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_led
			exit 0
		
		elif [ "$2" = "display" ];then
			if [ "$3" = "status" ];then
				if [ "$4" = "" -o "$5" = "" ];then
					echo "ERROR::input para is not right!"
					exit 1
				fi
				check_param 5 || exit $?
				send_hlp 120 0x20008004 0x4 8 "$4" "$5" || exit $?	
			else
					echo "ERROR::input para is not right!"
					exit 1					
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi

	elif [ "$1" = "gpio" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_gpio
			exit 0

		elif [ "$2" = "display" ];then
			if [ "$3" = "value" ];then
				check_param 4 || exit $?
				send_hlp 100 0x20012003 3 4 "$4" || exit $?

			else
				echo "ERROR::input para is not right!"
				exit 1					
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi

	elif [ "$1" = "i2c" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_i2c
			exit 0

		elif [ "$2" = "read" ];then
			if [ "$3" = "" -o "$4" = "" ];then
				echo "ERROR::input para is not right!"
				exit 1
			fi
			check_param 4 || exit $?
			ishex $4
			if [ $? -ne 1 ]; then
				echo "ERROR::input para is not right!"
				exit 1
			fi

			if [ "$3" = "A0" ];then
				send_hlp 100 0x20013000 0 8 0 0x"$4"0050 || exit $?
			elif [ "$3" = "A2" ];then
				send_hlp 100 0x20013000 0 8 0 0x"$4"0051 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1					
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi

	elif [ "$1" = "usb" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_usb
			exit 0

		elif [ "$2" = "display" ];then
			if [ "$3" = "status" ];then
				check_param 3 || exit $?
				send_hlp 150 0x2000c000 0x0 0 || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi
			
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
		
	elif [ "$1" = "codec" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_codec
			exit 0
		
		elif [ "$2" = "display" ];then
			if [ "$3" = "global" -a "$4" = "info" ];then
				check_param 5 || exit $?
				send_hlp 0 0x20006304 4 4 "$5" || exit $?
				send_hlp 80 0x20006307 0x7 4 "$5" || exit $?
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
				
	elif [ "$1" = "phy" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_phy
			exit 0
		elif [ "$2" = "display" ];then
			if [ "$3" = "debug" ];then
				if [ "$4" = "info" ];then
					check_param 4 || exit $?
				    sndhlp 0 0x2000900b 0xb 20 2 0 0 0 0 || exit $?
				else 
					echo "ERROR::input para is not right!"
					exit 1
				fi
				
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
	elif [ "$1" = "mpcp" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_mpcp
			exit 0
		
		elif [ "$2" = "switch" ];then
			check_param 3 || exit $?
			if [ "$3" = "on" ];then
				send_hlp 1000 0x20031006 0x6 4 0xff || exit $?
				
			elif [ "$3" = "off" ];then
				send_hlp 1000 0x20031006 0x6 4 0 || exit $?
			
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi

		elif [ "$2" = "display" ];then
			if [ "$3" = "statistics" ];then
				check_param 3 || exit $?
				send_hlp 1000 0x20031007 0x07 4 0 || exit $?				
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi		
		
	elif [ "$1" = "wifi" ];then
		if [ "$2" = "-h" ];then
			check_param 2 || exit $?
			help_wifi
			exit 0			
		else
			if [ -e /bin/hw_ldsp_wifi_cmd ];then
				hw_ldsp_wifi_cmd $@ || exit $?
			else
				echo "ERROR::Command is not right!"
				exit 1
			fi	
		fi

	elif [ "$1" = "mod" ];then
		if [ "$2" = "print" ];then
			check_param 5 || exit $?
			if [ "$3" = "hlp" ];then
				send_hlp 0 0x20000000 0 12 0 "$4" "$5" || exit $?
			elif [ "$3" = "lsw" ];then
#				send_hlp 0 0x20000000 0 12 1 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "gmac" ];then
#				send_hlp 0 0x20000000 0 12 2 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "ploam" ];then
				send_hlp 0 0x20000000 0 12 3 "$4" "$5" || exit $?
			elif [ "$3" = "dev" ];then
				send_hlp 0 0x20000000 0 12 4 "$4" "$5" || exit $?
			elif [ "$3" = "optic" ];then
				send_hlp 0 0x20000000 0 12 5 "$4" "$5" || exit $?
			elif [ "$3" = "codec" ];then
				send_hlp 0 0x20000000 0 12 6 "$4" "$5" || exit $?
			elif [ "$3" = "key" ];then
				send_hlp 0 0x20000000 0 12 7 "$4" "$5" || exit $?
			elif [ "$3" = "led" ];then
				send_hlp 0 0x20000000 0 12 8 "$4" "$5" || exit $?
			elif [ "$3" = "flash" ];then
				send_hlp 0 0x20000000 0 12 9 "$4" "$5" || exit $?
			elif [ "$3" = "battery" ];then
				send_hlp 0 0x20000000 0 12 10 "$4" "$5" || exit $?
			elif [ "$3" = "rf" ];then
				send_hlp 0 0x20000000 0 12 11 "$4" "$5" || exit $?
			elif [ "$3" = "usb" ];then
				send_hlp 0 0x20000000 0 12 12 "$4" "$5" || exit $?
			elif [ "$3" = "phy" ];then
				send_hlp 0 0x20000000 0 12 13 "$4" "$5" || exit $?
			elif [ "$3" = "dsp" ];then
				send_hlp 0 0x20000000 0 12 14 "$4" "$5" || exit $?
			elif [ "$3" = "emac" ];then
#				send_hlp 0 0x20000000 0 12 15 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "oam" ];then
				send_hlp 0 0x20000000 0 12 16 "$4" "$5" || exit $?
			elif [ "$3" = "wifi" ];then
				send_hlp 0 0x20000000 0 12 17 "$4" "$5" || exit $?
			elif [ "$3" = "gpio" ];then
				send_hlp 0 0x20000000 0 12 18 "$4" "$5" || exit $?
			elif [ "$3" = "i2c" ];then
				send_hlp 0 0x20000000 0 12 19 "$4" "$5" || exit $?
			elif [ "$3" = "mdio" ];then
#				send_hlp 0 0x20000000 0 12 20 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "uart" ];then
				send_hlp 0 0x20000000 0 12 21 "$4" "$5" || exit $?
			elif [ "$3" = "highway" ];then
				send_hlp 0 0x20000000 0 12 22 "$4" "$5" || exit $?
			elif [ "$3" = "e2prom" ];then
				send_hlp 0 0x20000000 0 12 23 "$4" "$5" || exit $?
			elif [ "$3" = "spi" ];then
				send_hlp 0 0x20000000 0 12 24 "$4" "$5" || exit $?
			elif [ "$3" = "sim" ];then
				send_hlp 0 0x20000000 0 12 25 "$4" "$5" || exit $?
				send_hlp 0 0x20019004 0x4 0 || exit $?
			elif [ "$3" = "serial" ];then
				send_hlp 0 0x20000000 0 12 26 "$4" "$5" || exit $?
			elif [ "$3" = "acl" ];then
#				send_hlp 0 0x20000000 0 12 28 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "napt" ];then
#				send_hlp 0 0x20000000 0 12 29 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "extlsw" ];then
#				send_hlp 0 0x20000000 0 12 36 "$4" "$5" || exit $?
                exit 1
			elif [ "$3" = "common" ];then
				send_hlp 0 0x20000000 0 12 34 "$4" "$5" || exit $?
			elif [ "$3" = "topo" ];then
				send_hlp 0 0x20000000 0 12 44 "$4" "$5" || exit $?			
			else
				echo "ERROR::input para is not right!"
				exit 1
			fi
		
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
	elif [ "$1" = "print" ];then
		if [ "$2" = "on" -o "$2" = "off" ]; then
		   check_param 2 || exit $?
		    if [ "$2" = "on" ];then
			    mid set 110 1
		    elif [ "$2" = "off" ];then
			    mid set 110 0
		    fi			
		else
			echo "ERROR::input para is not right!"
			exit 1
		fi
		
	else 
		echo "ERROR::Command is not right!"
		exit 1
	fi
