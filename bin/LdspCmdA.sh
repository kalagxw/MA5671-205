#!/bin/sh
clearall()
{
		sndhlp 0 0x2000160f 15 0 >> /dev/null
		sndhlp 0 0x2000160a 10 4 128 >> /dev/null
		sndhlp 0 0x2000160c 12 0 >> /dev/null
		sndhlp 0 0x2000160e 14 0 >> /dev/null
}

help_soc()
{
		echo "         soc"
		echo "                 -h  --- Get help of SOC Module"
		echo "                 rx/recvstat  --- Get statistics of the received packet"     
		echo "                 tx/transtat  --- Get statistics of the send packet"  
		echo "                 flowstat  --- Get statistics of the flow info"
		echo "                 queuestat  [queueid] --- Get statistics of the queue, queueid[1-127]"
		echo "                 clearqs   [queueid] --- Clear statistics of the queue, queueid[1-127]"
		echo "                 queuestat all  --- Get statistics of all queues"
		echo "                 clearqs all    --- Clear statistics of all queues"	
		echo "                 drop/dropres   --- Get the reason of drop packets"
		echo "                 throes  --- Get the reason of transparent packets"
		echo "                 tocpures  --- Get the reason of packets sended to CPU"
		echo "                 qosstat  ---  Get statistics of Qos"
		echo "                 display l2 clear  ---  Clear statistics of l2"
		echo "                 display l2 stat  ---  Get statistics of l2"
		echo "                 display route nh [index]  ---  Get statistics of route rt table,index[0-128](if index is none,getting all statistics )"
		echo "                 display route rt [index]  ---  Get statistics of route rt table,index[0-128](if index is none,getting all statistics )"
		echo "                 display route act [index]  ---  Get the action of route,index[0-255]"
        echo "                 display route replace [index]  ---  Get the replace action of route,index[0-255]"
		echo "                 display napt replace [index]  ---  Get the replace action of napt,index[0-255]"
        echo "                 display route sta [index]  ---  Get hit of route,index[0-255]"
        echo "                 display tun sta [index]  ---  Get hit of route,index[0-7]"		
        echo "                 display tunnel  ---  Get statistics of the tunnel"
		echo "                 display sdk version  ---  Get information of the sdk and chip"	
		echo ""
}

help_extlsw()
{
		echo "         extlsw "
		echo "                 -h  --- Get help of extend LSW Module"
		echo "                 display statistics [portid]  --- Get statistics of eth port, portid[0x200001-0x200004]" 
		echo "                 display mac  [address] ---Get the value of mac register, whilie address is the mac reg address"
		echo "                 display vlan [vlanid]---Get port of the vlan, vlanid[0-4095]"
		echo "                 display port vlan [portid] ---Get port of the vlan" Display the vlan information in port
		echo "                 display acl [aclid]  ---Get acl rule info"
		echo "                 display user rule  ---Get the relationship of the acl rule id and the user id"
		echo ""
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
		echo "                 display direct [gpio] ---Get direction of gpio"
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
		echo "                 display reg [phyid] [page] [reg]  ---Get the value of PHY register"
		echo "                 display glb [portid] Get all informations of ports" 
		echo ""
}

help_mpcp()
{
		echo "         mpcp"
		echo "                 switch on/off --- Open/Close the switch of MPCP"
		echo "                 display statistics --- Get statistics of MPCP"
		echo ""
}

help_other()
{
		echo "         clear --- Clear statistics of Soc"
		echo "         clearall --- Clear all the statistics"
		echo "         loghlp [cmd] on --- Open the switch of the specified hlp command"
		echo "         loghlp [cmd] off ---  Close the switch of the specified hlp command"
		echo "         mod print [module_name] [lever] [on/off] --- Open the switch of specified module and level"
		echo "         print on --- Open the printed switch of syslog"
		echo "         print off --- Close the printed switch of syslog"
		echo ""
}
	if [ "$1" = "-h" ];then
		echo "Usage:[module] [command] [option]"
		help_soc
		help_extlsw
		help_ploam
		help_optic
		help_led
		help_gpio
		help_i2c
		help_usb
		help_phy
		help_mpcp
		help_codec
		help_other
		exit 1
		
	elif [ "$1" = "clear" ];then
		sndhlp 0 0x2000160f 15 0 >> /dev/null
		
	elif [ "$1" = "clearall" ];then
		clearall
		
	elif [ "$1" = "soc" ];then
		if [ "$2" = "-h" ];then
			help_soc
			exit 1
		fi
		
		if [ "$2" = "recvstat" ];then
			sndhlp 0 0x20001602 2 0 >> /dev/null
		fi

		if [ "$2" = "rx" ];then
			sndhlp 0 0x20001602 2 0 >> /dev/null
		fi
		
		if [ "$2" = "transtat" ];then
			sndhlp 0 0x20001603 3 0 >> /dev/null
		fi

		if [ "$2" = "tx" ];then
			sndhlp 0 0x20001603 3 0 >> /dev/null
		fi
		
		if [ "$2" = "dropres" ];then
			sndhlp 0 0x20001604 4 0 >> /dev/null
		fi

		if [ "$2" = "drop" ];then
			sndhlp 0 0x20001604 4 0 >> /dev/null
		fi
		
		if [ "$2" = "throes" ];then
			sndhlp 0 0x2000160b 11 4 1 >> /dev/null
		fi

		if [ "$2" = "tocpures" ];then
			sndhlp 0 0x2000160b 11 4 2 >> /dev/null
		fi

		if [ "$2" = "qosstat" ];then
			sndhlp 0 0x2000160d 13 0 >> /dev/null
		fi

		if [ "$2" = "flowstat" ];then
			sndhlp 0 0x20001606 6 4 2 >> /dev/null
		fi

		if [ "$2" = "queuestat" ];then
			sndhlp 0 0x20001614 0x14 264 1 0 8 "$3" >> /dev/null
		fi

		if [ "$2" = "queuestat" ];then
		    if [ "$3" = "all" ];then
				sndhlp 0 0x20001614 0x14 264 1 0 8  128 >> /dev/null
			fi
		fi
	
		if [ "$2" = "clearqs" ];then
			sndhlp 0 0x2000160a 10 4 "$3" >> /dev/null
		fi

		if [ "$2" = "clearqs" ];then
		    if [ "$3" = "all" ];then
				sndhlp 0 0x2000160a 10 4 128 >> /dev/null
			fi
		fi
		
		if [ "$2" = "set_tag_mode" ];then
			if [ "$3" = "" -o "$4" = "" -o "$5" = "" -o "$6" = "" ];then
				echo "The command is:"
				echo "$0 $1 $2 sportid tagmode vlanid pri"
			else
				sndhlp 80 0x20001204 4 16 "$3" "$4" "$5" "$6"
			fi
		fi

		if [ "$2" = "display" ];then
		     if [ "$3" = "l2" ];then
		         if [ "$4" = "clear" ];then
		             sndhlp 0 0x20001613 19 0 0 >> /dev/null
				 fi
			 fi	 
		fi		

		if [ "$2" = "display" ];then
		     if [ "$3" = "l2" ];then
		         if [ "$4" = "stat" ];then
		             sndhlp 0 0x20001608 8 0 0 >> /dev/null
				 fi
			 fi	 
		fi

		if [ "$2" = "display" ];then
		    if [ "$3" = "route" ];then
		        if [ "$4" = "nh" ];then
                    if [ "$5" = "" ];then	   
     			        sndhlp 0 0x20035203 3 264 2 4 256 >> /dev/null			
			        else
			            sndhlp 0 0x20035203 3 264 2 4 "$5" >> /dev/null
			        fi 
				fi
			fi
		fi

		if [ "$2" = "display" ];then
		    if [ "$3" = "route" ];then
		        if [ "$4" = "rt" ];then
		            if [ "$5" = "" ];then	   
		                sndhlp 0 0x20035203 3 264 1 4 256 >> /dev/null		
			            else
			            sndhlp 0 0x20035203 3 264 1 4 "$5" >> /dev/null
					fi
				fi
            fi					 
		fi
		
		if [ "$2" = "display" ];then
		    if [ "$3" = "napt" ];then
		        if [ "$4" = "replace" ];then
		            if [ "$5" = "" ];then	   
		                sndhlp 0 0x20035203 3 264 0x11 4 256 >> /dev/null		
			            else
			            sndhlp 0 0x20035203 3 264 0x11 4 "$5" >> /dev/null
					fi
				fi
            fi					 
		fi	

		if [ "$2" = "display" ];then
		     if [ "$3" = "route" ];then
		         if [ "$4" = "act" ];then   
			         sndhlp 0 0x20035203 3 264 4 4 "$5" >> /dev/null
				 fi
			 fi
		fi
		
		if [ "$2" = "display" ];then
		     if [ "$3" = "route" ];then
		         if [ "$4" = "replace" ];then
			         sndhlp 0 0x20035203 3 264 3 4 "$5" >> /dev/null
				 fi
			 fi
		fi

		if [ "$2" = "display" ];then
		     if [ "$3" = "tunnel" ];then
			     if [ "$4" = "" ];then
			         sndhlp 0 0x20035203 3 264 0xd 4 0xff >> /dev/null
				 else
				     sndhlp 0 0x20035203 3 264 0xd 4 "$4" >> /dev/null
				 fi
			 fi
		fi

		if [ "$2" = "display" ];then
		     if [ "$3" = "route" ];then
		         if [ "$4" = "sta" ];then
			         sndhlp 0 0x20035203 3 264 0x10 4 "$4" >> /dev/null
				 fi
			 fi
		fi

		if [ "$2" = "display" ];then
		     if [ "$3" = "tun" ];then
		         if [ "$4" = "sta" ];then
			         sndhlp 0 0x20035203 3 264 0xf 4 "$4" >> /dev/null
				 fi
			 fi
		fi
		
		if [ "$2" = "display" ];then
		     if [ "$3" = "sdk" ];then
		         if [ "$4" = "version" ];then
			         sndhlp 264 0x20001614 0x14 264 1 4 12 >> /dev/null
				 fi
			 fi
		fi		
		
	elif [ "$1" = "extlsw" ];then
		if [ "$2" = "-h" ];then
			help_extlsw
			exit 1
		fi
		
		if [ "$2" = "clear" ];then
			sndhlp 76 0x20001614 0x14 264 2 0 5  $3 >> /dev/null
	        fi		
	  
	  	if [ "$2" = "display" ];then
		    if [ "$3" = "statistics" ];then
			    sndhlp 76 0x20001614 0x14 264 2 0 4  $4 >> /dev/null
			fi
	  	fi		
	  		 								
		if [ "$2" = "display" ];then 
		    if [ "$3" = "mac" ];then
				if [ "$4" = "" ];then
					echo "The command is:"
					echo "$0 $1 $2 $3 address"
					exit 2
				fi
				sndhlp 76 0x20001601 1 12 2 "$4"
		    fi	
		fi		

		if [ "$2" = "display" ];then
		    if [ "$3" = "vlan" ];then
			    sndhlp 76 0x20001614 0x14 264 2 0 0 "$4" >> /dev/null
			fi
		fi

		if [ "$2" = "display" ];then
		    if [ "$3" = "port" ];then
			    if [ "$4" = "vlan" ];then
		            sndhlp 76 0x20001614 0x14 264 1 0 21 "$5" >> /dev/null		
					sndhlp 76 0x20001614 0x14 264 2 0 1 "$5" >> /dev/null
				fi
			fi
		fi		

		if [ "$2" = "get_tag_mode" ];then
			if [ "$3" = "" ];then
				echo "The command is:"
				echo "$0 $1 $2 portid "
				exit 2
			fi

			sndhlp 80 0x20001205 5 4 "$3" 					
		fi
			
		if [ "$2" = "display" ];then 
		    if [ "$3" = "acl" ];then 
				if [ "$4" = "" ];then
					echo "The command is:"
					echo "$0 $1 $2 $3 aclid"
					exit 2
				fi
				
				sndhlp 76 0x20001614 0x14 264 2 0 6 "$4"
			fi
		fi

		if [ "$1" = "extlsw" -a "$2" = "rule_user" ];then
			 sndhlp 76 0x20001614 0x14 264 2 0 7 
		fi						
					
	elif [ "$1" = "ploam" ];then
		if [ "$2" = "-h" ];then
			help_ploam
			exit 1
		fi
		
		if [ "$2" = "print" ];then
			 if [ "$3" = "on" ];then
				sndhlp 0 0x20003023 0x23 8  0  1 >> /dev/null
			 elif [ "$3" = "off" ];then
			 	sndhlp 0 0x20003023 0x23 8  0  0 >> /dev/null
			 fi 
		fi

		if [ "$2" = "alarm" ];then
			 if [ "$3" = "on" ];then
				sndhlp 0 0x20003023 0x23 8  1  1 >> /dev/null
			 elif [ "$3" = "off" ];then
			 	sndhlp 0 0x20003023 0x23 8  1  0 >> /dev/null
			 fi 
		fi

		if [ "$2" = "err" ];then
			 if [ "$3" = "on" ];then
				sndhlp 0 0x20003023 0x23 8  2  1 >> /dev/null
			  elif [ "$3" = "off" ];then
			 	sndhlp 0 0x20003023 0x23 8  2  0 >> /dev/null
			 fi 
		fi

		if [ "$2" = "omci" ];then
			 if [ "$3" = "on" ];then
				sndhlp 0 0x20003023 0x23 8  3  1 >> /dev/null
			  elif [ "$3" = "off" ];then
			 	sndhlp 0 0x20003023 0x23 8  3  0 >> /dev/null
			 fi 
		fi

		if [ "$2" = "stat" ];then
			sndhlp 0 0x20003026 0x26 4 1 >> /dev/null
		fi

		if [ "$2" = "clear" ];then
		    if [ "$3" = "stat" ];then
				sndhlp 0 0x20003025 0x25 4 1 >> /dev/null
			fi
		fi

		if [ "$2" = "bwmap" ];then
			sndhlp 0 0x20003024 0x24 0 0 >> /dev/null
		fi

	elif [ "$1" = "optic" ];then
		if [ "$2" = "-h" ];then
			help_optic
			exit 1
		fi
		
		if [ "$2" = "display" ];then
			if [ "$3" = "reg" ];then
				sndhlp 0 0x2000500d 0xd 20 1 0 0 0 0x70  
			fi
		fi

	elif [ "$1" = "led" ];then
		if [ "$2" = "-h" ];then
			help_led
			exit 1
		fi
		
		if [ "$2" = "display" ];then
			if [ "$3" = "status" ];then
			     if [ "$3" = "" -o "$4" = "" ];then
					echo "The commond is:"
					      echo "$0 $1 $2 $3 [ledid] [ledcolor]"
				 else
				    sndhlp 104 0x20008004 0x4 8 "$4" "$5"
			     fi
			fi
		fi

	elif [ "$1" = "gpio" ];then
		if [ "$2" = "-h" ];then
			help_gpio
			exit 1
		fi 

        if [ "$2" = "display" ];then
			if [ "$3" = "direct" ];then
				sndhlp 100 0x20012002 2 4 "$4"
			fi 

			if [ "$3" = "value" ];then
				sndhlp 100 0x20012004 4 4 "$4"
			fi
		fi

	elif [ "$1" = "i2c" ];then
		if [ "$2" = "-h" ];then
			help_i2c
			exit 2
		fi

		if [ "$2" = "read" ];then
			 if [ "$3" = "" -o "$4" = "" ];then
			 	echo "The command is:"
				echo "$0 $1 $2 A0/A2 address"
				exit 2
			 fi
			
			 if [ "$3" = "A0" ];then
				sndhlp 100 0x20013002 2 3 0x"$4"0050
			 elif [ "$3" = "A2" ];then
			 	sndhlp 100 0x20013002 2 3 0x"$4"0051
			 fi 
		fi

	elif [ "$1" = "usb" ];then
		if [ "$2" = "-h" ];then
			help_usb
			exit 2
		fi

		if [ "$2" = "display" ];then
		    if [ "$3" = "status" ];then
			sndhlp 150 0x2000c000 0x0 0
			fi
		fi
	
		
	elif [ "$1" = "codec" ];then
		if [ "$2" = "-h" ];then
			help_codec
			exit 2
		fi		
		
		if [ "$2" = "display" ];then
		    if [ "$3" = "global" ];then
		        if [ "$4" = "info" ];then    
					sndhlp 0 0x20006304 4 4 "$5"
					sndhlp 80 0x20006307 0x7 4 "$5"
				fi
			fi
		fi
				
	elif [ "$1" = "phy" ];then
		if [ "$2" = "-h" ];then
			help_phy
			exit 2
		fi

		if [ "$2" = "display" ];then
		     if [ "$3" = "reg" ];then
				 if [ "$4" = "" -o "$5" = "" -o "$6" = "" ];then
				 	echo "The command is:"
					echo "$0 $1 $2 $3 phyid page reg "
					exit 2
				 fi
				 sndhlp 0 0x20014002 0x2 100 27 "$4" "$5" "$6"
			 fi
		fi

		if [ "$2" = "display" ];then
			if [ "$3" = "glb" ];then
				 if [ "$4" = "" ];then
				 	echo "The command is:"
					echo "$0 $1 $2 $3 portid "
					exit 2
				 fi
				sndhlp 0 0x20014002 0x2 100 28 "$4" 
			fi
	    fi
	    
	elif [ "$1" = "mpcp" ];then
		if [ "$2" = "-h" ];then
			help_mpcp
			exit 2
		fi
		
		if [ "$2" = "switch" ];then
		    if [ "$3" = "on" ];then
			sndhlp 1000 0x2000f01b 0x1b 4 0xff >> /dev/null
			elif [ "$3" = "off" ];then
			sndhlp 1000 0x2000f01b 0x1b 4 0 >> /dev/null
			fi
		fi

		if [ "$2" = "display" ];then
		    if [ "$3" = "statistics" ];then
				sndhlp 1000 0x2000f012 0x12 4 0x010100
				sndhlp 1000 0x2000f019 0x19 4 0
				sndhlp 1000 0x2000f01a 0x1a 4 0
			fi
		fi		

	elif [ "$1" = "loghlp" ];then
		if [ "$2" = "" -o "$3" = "" ];then
				echo "The command is:"
				echo "$0 $1 [cmd] 0/1 "
				exit 2
		fi
			
		if [ "$3" = "on" ];then
			sndhlp 0 0x20000000 0 20 0 1 1 1 "$2"  >> /dev/null
		elif [ "$3" = "off" ];then
			sndhlp 0 0x20000000 0 20 0 1 1 0 "$2" >> /dev/null
		fi 

	elif [ "$1" = "mod" ];then
	    if [ "$2" = "print" ];then
			if [ "$3" = "hlp" ];then
				sndhlp 0 0x20000000 0 12 0 "$4" "$5" >> /dev/null
			elif [ "$3" = "lsw" ];then
				sndhlp 0 0x20000000 0 12 1 "$4" "$5" >> /dev/null
			elif [ "$3" = "gmac" ];then
				sndhlp 0 0x20000000 0 12 2 "$4" "$5" >> /dev/null
			elif [ "$3" = "ploam" ];then
				sndhlp 0 0x20000000 0 12 3 "$4" "$5" >> /dev/null
			elif [ "$3" = "dev" ];then
				sndhlp 0 0x20000000 0 12 4 "$4" "$5" >> /dev/null
			elif [ "$3" = "optic" ];then
				sndhlp 0 0x20000000 0 12 5 "$4" "$5" >> /dev/null
			elif [ "$3" = "codec" ];then
				sndhlp 0 0x20000000 0 12 6 "$4" "$5" >> /dev/null
			elif [ "$3" = "key" ];then
				sndhlp 0 0x20000000 0 12 7 "$4" "$5" >> /dev/null
			elif [ "$3" = "led" ];then
				sndhlp 0 0x20000000 0 12 8 "$4" "$5" >> /dev/null
			elif [ "$3" = "flash" ];then
				sndhlp 0 0x20000000 0 12 9 "$4" "$5" >> /dev/null
			elif [ "$3" = "battery" ];then
				sndhlp 0 0x20000000 0 12 10 "$4" "$5" >> /dev/null
			elif [ "$3" = "rf" ];then
				sndhlp 0 0x20000000 0 12 11 "$4" "$5" >> /dev/null
			elif [ "$3" = "usb" ];then
				sndhlp 0 0x20000000 0 12 12 "$4" "$5" >> /dev/null
			elif [ "$3" = "phy" ];then
				sndhlp 0 0x20000000 0 12 13 "$4" "$5" >> /dev/null
			elif [ "$3" = "dsp" ];then
				sndhlp 0 0x20000000 0 12 14 "$4" "$5" >> /dev/null
			elif [ "$3" = "emac" ];then
				sndhlp 0 0x20000000 0 12 15 "$4" "$5" >> /dev/null
			elif [ "$3" = "oam" ];then
				sndhlp 0 0x20000000 0 12 16 "$4" "$5" >> /dev/null
			elif [ "$3" = "wifi" ];then
				sndhlp 0 0x20000000 0 12 17 "$4" "$5" >> /dev/null
			elif [ "$3" = "gpio" ];then
				sndhlp 0 0x20000000 0 12 18 "$4" "$5" >> /dev/null
			elif [ "$3" = "i2c" ];then
				sndhlp 0 0x20000000 0 12 19 "$4" "$5" >> /dev/null
			elif [ "$3" = "mdio" ];then
				sndhlp 0 0x20000000 0 12 20 "$4" "$5" >> /dev/null
			elif [ "$3" = "uart" ];then
				sndhlp 0 0x20000000 0 12 21 "$4" "$5" >> /dev/null
			elif [ "$3" = "highway" ];then
				sndhlp 0 0x20000000 0 12 22 "$4" "$5" >> /dev/null
			elif [ "$3" = "e2prom" ];then
				sndhlp 0 0x20000000 0 12 23 "$4" "$5" >> /dev/null
			elif [ "$3" = "spi" ];then
				sndhlp 0 0x20000000 0 12 24 "$4" "$5" >> /dev/null
			elif [ "$3" = "pci" ];then
				sndhlp 0 0x20000000 0 12 25 "$4" "$5" >> /dev/null
			elif [ "$3" = "serial" ];then
				sndhlp 0 0x20000000 0 12 26 "$4" "$5" >> /dev/null
			elif [ "$3" = "qos" ];then
				sndhlp 0 0x20000000 0 12 27 "$4" "$5" >> /dev/null
			elif [ "$3" = "acl" ];then
				sndhlp 0 0x20000000 0 12 28 "$4" "$5" >> /dev/null
			elif [ "$3" = "napt" ];then
				sndhlp 0 0x20000000 0 12 29 "$4" "$5" >> /dev/null
			elif [ "$3" = "extlsw" ];then
				sndhlp 0 0x20000000 0 12 36 "$4" "$5" >> /dev/null
			elif [ "$3" = "common" ];then
				sndhlp 0 0x20000000 0 12 34 "$4" "$5" >> /dev/null
			elif [ "$3" = "topo" ];then
				sndhlp 0 0x20000000 0 12 44 "$4" "$5" >> /dev/null			
			else
				echo "the command not support!"
			fi 
        fi
	elif [ "$1" = "print" ];then
		    if [ "$2" = "on" ];then
			    mid set 0x6e 1
		    elif [ "$2" = "off" ];then
			    mid set 0x6e 0
		    fi
		
	else 
	
		echo "Command is error!"
	fi


