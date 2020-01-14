var DisliteFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BTV_WAN_PROTOCOL_IGNORE);%>";
var selctIndex = -1;

function trim(str)
{
   if (str.charAt(0) == " ")
   {
      str = str.substring(1, str.length);
      str = trim(str);
   }
   if (str.charAt(str.length - 1) == " ")
   {
      str = str.substring(0, str.length - 1);
      str = trim(str);
   }
   return str;
}


function IsIPv6AddressUshortValid(Short)
{
    if (Short.length > 4)
    {
        return false;
    }
    
    for (var i = 0; i < Short.length; i++)
    {
        var Char = Short.charAt(i);
        if (!((Char >= '0' && Char <= '9') || (Char >= 'a' && Char <= 'f') || (Char >= 'A' && Char <= 'F')))
        {
            return false;
        }
    }
    
    return true;
}

function IsStandardIPv6AddressValid(Address)
{
    if ((Address.charAt(0) == ':') || (Address.charAt(Address.length-1) == ':'))
    {
        return false;
    }    
    
    List = Address.split(":");
    if (List.length > 8)
    {
        return false;
    }

    for (var i = 0; i < List.length; i++)
    {
        if (false == IsIPv6AddressUshortValid(List[i]))
        {
            return false;
        }
    }    
    
    return true;   
}

function IsIPv6AddressValid(Address)
{
    if (Address == "::")
    {
        return true;
    }

    if (Address.length < 3)
    {
        return false;
    }

    var List = Address.split("::");
    if (List.length > 2)
    {
        return false;
    }
    
    if (List.length == 1)
    if (Address.split(":").length != 8)
    {
        return false;
    }
    
    if (List.length > 1)
    if (Address.split(":").length > 8)
    {
        return false;
    }

    List = Address.split("::");
    for (var i = 0; i < List.length; i++)
    {
        if (false == IsStandardIPv6AddressValid(List[i]))
        {
            return false;
        }
    }
    return true;
}


function IsIPv6ZeroAddress(Address)
{
    for (var i = 0; i < Address.length; i++)
    {
        if (Address.charAt(i) != '0' && Address.charAt(i) != ':')
        {
            return false;
        }
    }
    
    return true;
}


function IsIPv6LoopBackAddress(Address)
{
    if (Address.substr(Address.length-1,1) == "1")
    {
        if (IsIPv6ZeroAddress(Address.substr(0, Address.length-1)+"0") == true)
        {
            return true;
        }
    }
    return false;
}

function IsIPv6LinkLocalAddress(Address)
{
    var IntAddress = parseInt(Address.toUpperCase().substr(0, 4), 16);
    var StartAddress = parseInt("FE80", 16);
    var EndAddress = parseInt("FEBF", 16);
    return (IntAddress >= StartAddress && IntAddress <= EndAddress) ? true : false; 
}

function IsIPv6SiteLocalAddress(Address)
{
    var IntAddress = parseInt(Address.toUpperCase().substr(0, 4), 16);
    var StartAddress = parseInt("FEC0", 16);
    var EndAddress = parseInt("FEFF", 16);
    return (IntAddress >= StartAddress && IntAddress <= EndAddress) ? true : false; 
}

function IsIPv6MulticastAddress(Address)
{
    return (parseInt(Address.split(":")[0], 16) >= parseInt("0xFF00", 16)) ? true : false;
}

function IsIPv6UlaAddress(Address)
{
	var firstAddress = Address.split(":")[0];
	
	if(firstAddress.length != 4)
	{
		return false;
	}
	
    return (parseInt(firstAddress.substr(0, 2), 16) == parseInt("0xFD", 16)) ? true : false;
}

function CheckIpv6Parameter(IPv6Address)
{
	if (IsIPv6AddressValid(IPv6Address) == false)
	{
	    return false;
	}

	if (IsIPv6MulticastAddress(IPv6Address) == true)
	{
	    return false;  
	} 

	if (IsIPv6ZeroAddress(IPv6Address) == true) 
	{
	    return false;
	}

	if (IsIPv6LoopBackAddress(IPv6Address) == true)
	{
	    return false;  
	}
	return true; 
}

function isValidVenderClassID(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if (ch == '&' || ch == '*' || ch == '(' || ch == ')'
            || ch == '`' || ch == ';' || ch == '\"' || ch == '\'' 
            || ch == '<' || ch == '>' || ch == '#' || ch == '|')
        {
            return ch;
        }
    }
    return '';
}

function SearchTr069WanInstanceId()
{
    var CurWanService = '';
    var Wan = GetWanList();
	
	for(var i = 0; i < Wan.length; i++)
	{
		CurWanService = Wan[i].ServiceList;
		if ((CurWanService.indexOf("TR069") >=0 ) && (Wan[i].AccessType != 0))
		{
		    return Wan[i].domain;
		}
	}
    
    return "";
}

function CheckIPv6AddrMaskLenE8c(wan)
{
	if (isNaN(wan.IPv6AddrMaskLenE8c) == true || parseInt(wan.IPv6AddrMaskLenE8c,10) < 10 
	|| parseInt(wan.IPv6AddrMaskLenE8c,10) > 128 || isNaN(wan.IPv6AddrMaskLenE8c.replace(' ', 'a')) == true)
	{
		return false;     
	}
    return true;
}


function CheckDstIPForwardingCfg(Wan)
{
  var DstIPForwardingList = Wan.DstIPForwardingList;
  var ipStart;
  var ipEnd;
  var ipList;

  if(!DstIPForwardingList.length)
  {
  	return true;
  }

  DstIPForwardingList = DstIPForwardingList.split(",");
	var checkflag = false;
	for (var i = 0; i < DstIPForwardingList.length; i++)
	{	
		if(DstIPForwardingList[i] == "")
		{
			AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_invalid_formate']);
			return false;
		}
		checkflag = false;
		for(var j = 0; j < DstIPForwardingList[i].length; j++ )
		{
			var ch = DstIPForwardingList[i].charAt(j);
			if(ch == '-')
			{
				checkflag = true;
				break;
			}
		}
		if(checkflag)
		{
			ipList = DstIPForwardingList[i].split("-");

			if (ipList.length != 2)
			{
				AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_invalid_formate']);
				return false;
			}
		

			ipStart = ipList[0];
			ipEnd   = ipList[1];
			
			if (ipEnd != "" && ipStart != "" 
		        && (IpAddress2DecNum(ipStart) > IpAddress2DecNum(ipEnd)))
        	{
    	    	AlertEx(ipStart+ dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_ip_error2'] +ipEnd);
    		    return false;     	
    	    }
			
			if (false == (CheckIpAddressValid(ipStart)))
			{
				AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_invalid_formate']);
				return false;
			}
			if (false == (CheckIpAddressValid(ipEnd)))
			{
				AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_invalid_formate']);
				return false;
			}
		}
		else
		{
			ipStart = DstIPForwardingList[i];
			ipEnd = DstIPForwardingList[i];
		}
		
		
		if (false == (CheckIpAddressValid(ipStart)))
		{
			AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_ip_error']+"("+ipStart+")");
			return false;
		}

		if (false == (CheckIpAddressValid(ipEnd)))
		{
			AlertEx(dst_ip_forwarding_cfg_ctc_language['bbsp_dst_ip_forwarding_ip_error']+"("+ipEnd+")");
			return false;
		}
		
	}

	return true;
}

function isSameIPv6SubNet(Ip1,Ip2,IPv6MaskLen) 
{
	var count = 0;
	var i = 0;
	var j = 0;
	var strMask = "";
	var Ip1_str = ":0:";
	var Ip2_str = ":0:";
	var Ip1_list = Ip1.split('::');
	var Ip2_list = Ip2.split('::');
	
	if(Ip1_list.length == 1)
	{
		Ip1_list = Ip1;
	}
	if(Ip2_list.length == 1)
	{
		Ip2_list = Ip2;
	}
   
	if(Ip1_list.length == 2)
	{
		if(Ip1_list[0] == "")
		{
			Ip1_list[0] = "0";
		}
		if(Ip1_list[1] == "")
		{
			Ip1_list[1] = "0";
		}
		Ip1_list1 = Ip1.split(':');
		for(i = 0; i < 8 - Ip1_list1.length; i++ )
		{
			Ip1_str += "0:";
		}
		Ip1_list = Ip1_list[0] + Ip1_str +  Ip1_list[1];
	}
	
	if(Ip2_list.length == 2)
	{
		if(Ip2_list[0] == "")
		{
			Ip2_list[0] = "0";
		}
		if(Ip2_list[1] == "")
		{
			Ip2_list[1] = "0";
		}
		Ip2_list2 = Ip2.split(':');
		for(j = 0; j < 8 - Ip2_list2.length; j++ )
		{
			Ip2_str += "0:";
		}
		Ip2_list = Ip2_list[0] + Ip2_str +  Ip2_list[1];
	}

	if(IPv6MaskLen == "")
	{
		IPv6MaskLen = 64;
	}
	for(i = 0; i< 128 ;i++)
	{
		if(i < IPv6MaskLen)
		{
			strMask += "1";
		}
		else
		{
			strMask += "0";
		}
		if((i+1)%16 == 0)
		{
			strMask += ":";
		}
	}
	strMask = strMask.substring(0,strMask.lastIndexOf(':'));
   
	lanm = strMask.split(':');
	lan1a = Ip1_list.split(':');
	lan2a = Ip2_list.split(':');
	
	for(i = 0; i < 8; i++)
	{
		l1a_n = parseInt(lan1a[i],16);
		l2a_n = parseInt(lan2a[i],16);
		lm_n = parseInt(lanm[i],2);
		if ((l1a_n & lm_n) == (l2a_n & lm_n))
		count++;
	}
   
	if (count == 8)
		return true;
	else
		return false;
}


function GetRouteWanCount()
{
    var WanList = GetWanList();
    var Count = 0; 
    for (var i = 0; i < WanList.length; i++)
    {
        if (WanList[i].Mode == "IP_Routed")
        {
            Count++;
        }
    }
    
    return Count;
}

function isNum(str)
{
    var valid=/[0-9]/;
    var i;
    for(i=0; i<str.length; i++)
    {
        if(false == valid.test(str.charAt(i)))
        {
        	return false;
        }
    }
    return true;
}

var errmsg="";
var ERR_MUST_INPUT=1;
var ERR_First_CHAR_NOT_ZERO=ERR_MUST_INPUT+1;
var ERR_MUST_NUM=ERR_First_CHAR_NOT_ZERO+1;
var ERR_NOT_IN_RANGE=ERR_MUST_NUM+1;

function getErrorMsg(fieldPrompt,errcode)
{

  var error=new Array("","MustBeInput","IsNumFirstChar","IsNum","VlanIDRange");

  var errorCN=new Array("","VLAN必须输入","VLAN ID第一个字符不能为0","VLAN ID不合法，它只能是数字","VLAN ID 范围1~4094");
  
  if(fieldPrompt!="")
  {
    return GetLanguage(fieldPrompt)+GetLanguage(error[errcode]);   
  }else 
  {
     return errorCN[errcode];
  }
}
function checkVlanID(VlanID,fieldPrompt)
{
	if('' == VlanID)
	{
			return getErrorMsg(fieldPrompt,ERR_MUST_INPUT);
	}
  if ( VlanID.length > 1 && VlanID.charAt(0) == '0' )
  {
      return getErrorMsg(fieldPrompt,ERR_First_CHAR_NOT_ZERO);
  }
	if( false == isInteger(VlanID) )
	{
	    return getErrorMsg(fieldPrompt,ERR_MUST_NUM);
	}
  if ( false == CheckNumber(VlanID,1, 4094) )
  {
      return getErrorMsg(fieldPrompt,ERR_NOT_IN_RANGE);
  }

  return "";
}

function CheckRouteBridgeCoexist(newWan, existWan)
{
    if (('PPPoE_Bridged' == newWan.Mode) || ('IP_Bridged' == newWan.Mode))
    {
		if ('IP_Routed' == existWan.Mode)
		{
		    return true;
		}
	}
	else if ('IP_Routed' == newWan.Mode)
	{
	    if (('PPPoE_Bridged' == existWan.Mode) || ('IP_Bridged' == existWan.Mode))
		{
			return true;
		}
	}
	return false;
}

function CheckForSession(Wan, AddFlag)
{
    if (AddFlag != 2)
    {
        return true;
    }
    
    var SessionVlanLimit  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULT_SESSION_VLAN_LIMIT);%>";
    if (SessionVlanLimit == 0)
    {
        return true;
    }
    var wanConInst = GetWanInfoSelected().domain.split(".")[4];
    var domainTmp = 'InternetGatewayDevice.WANDevice.1.WANConnectionDevice.' + wanConInst + '.';
    var wanListTmp = GetWanList();
    var maxCnt = 1;
    var tmpCnt = 0;
	
    for (var  index1=0; index1 < wanListTmp.length; index1++ )
    {
      
        if (wanListTmp[index1].domain.indexOf(domainTmp) >= 0)
        {
            tmpCnt++;
        }
		
        if (tmpCnt > maxCnt)
        {
            AlertMsg("SessionIsFull");
            return false;
        }
    }

    return true;
}
var FtBin5Enhanced = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BIN5_ENHANCED);%>";
function CheckWan(Wan)
{	
    var RouteWanNum = GetRouteWanMax();

    if ((Wan.domain == null || (Wan.domain != null && Wan.domain.length < 10)) && GetRouteWanCount() >= RouteWanNum && Wan.Mode == "IP_Routed")
    {
        AlertMsg("RouteWanIsFull");
        return false;   
    }

	if ((BirdgetoRoute() == true) && GetRouteWanCount() >= RouteWanNum)
	{
		AlertMsg("RouteWanIsFull");
		return false;   
	}
	 
	 if((Wan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) && (Wan.ServiceList != 'INTERNET') && (Wan.ServiceList != 'IPTV') && (Wan.ServiceList != 'OTHER'))
	 {
		if ("1" != GetCfgMode().TELMEX)
		{
			AlertMsg("Wanlisterror");
			return false;
		}
	 }
	 if((Wan.Mode.toUpperCase().indexOf("ROUTE") >= 0) && (Wan.ServiceList != 'TR069') && (Wan.ServiceList != 'VOIP') && (Wan.ServiceList != 'TR069_VOIP')){
		 	if ("1" == FtBin5Enhanced){
			 	AlertMsg("Wanlisterror2");
				return false;
		 }
	 }

    var VlanID = Wan.VlanId;
	

    if ( "1" == Wan.EnableVlan)
    {
      errmsg="";
	    errmsg=checkVlanID(VlanID,"VlanId");
	    if(""!=errmsg)
        {
	  	   AlertEx(errmsg);
	
             return false;
    }
	
    }
   

    var IPv4MultiVlanID = Wan.IPv4WanMVlanId;
	  if("" != IPv4MultiVlanID && '1' == Wan.IPv4Enable)
	{
	    errmsg="";
	    errmsg=checkVlanID(IPv4MultiVlanID,"WanMVlanId");
	    if(""!=errmsg)

	
	    {
	  	   AlertEx(errmsg);
		
	        return false;
	    }
    }
	 if(('0' == Wan.IPv4Enable)
	    &&('0' == DisliteFeature))
	 {
	 	Wan.IPv4WanMVlanId =0 ;
	 }
	 
	 if('0' == Wan.IPv6Enable)
	 {
	 	Wan.IPv6WanMVlanId =0;
	 }
	
	if (false == CheckDstIPForwardingCfg(Wan))
	{
		return false;
	}

	
	if (false == CheckNumber(Wan.IPv6AddrMaskLenE8c, 10, 128) && (Wan.IPv6AddrMaskLenE8c != ""))
	{
	    AlertMsg("IPv6AddrMaskLenE8cError");
		return false;
	}
	
	if((Wan.ProtocolType.toString() == "IPv6") && (Wan.IPv6DSLite.toString() != "Off"))
	{
		Wan.IPv6WanMVlanId = 0;
	}
	 

	if (Wan.IPv6Enable == "1" && Wan.IPv6WanMVlanId !="" )
	{
	    errmsg="";
		  errmsg=checkVlanID(Wan.IPv6WanMVlanId,"WanMVlanId");
	    if(""!=errmsg)
		{
	  	   AlertEx(errmsg);
		
	        return false;
	    }
	}

    if('IP_Bridged' == Wan.Mode || 'PPPoE_Bridged' == Wan.Mode)
    {
        return true;
    }

	if(('IP_Routed' == Wan.Mode) && (Wan.AccessType != 0))
	{
		var addWanService = Wan.ServiceList;
		var currInstanceId = SearchTr069WanInstanceId();
		if(currInstanceId != "" && currInstanceId != Wan.domain && addWanService.indexOf("TR069") >= 0)
		{
			AlertMsg("OnlyOneTr069Wan");
			return false;
		}
	}

	
	
    if(('1' == Wan.IPv4Enable)&&('Static' == Wan.IPv4AddressMode)&&(Wan.IPv4SubnetMask == ''))
    {
        AlertMsg("SubMaskInput");
        return false;
    }
	
	
    if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && (isValidIpAddress(Wan.IPv4IPAddress) == false || isAbcIpAddress(Wan.IPv4IPAddress) == false))
    {
         AlertMsg("IPAddressInvalid");
         return false;
    }
	
    if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && isValidSubnetMask(Wan.IPv4SubnetMask) == false )
    {
        AlertMsg("SubMaskInvalid");
        return false;
    }
	
    if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && Wan.IPv4PrimaryDNS != '' && (isValidIpAddress(Wan.IPv4PrimaryDNS) == false || isAbcIpAddress(Wan.IPv4PrimaryDNS) == false))
    {
        AlertMsg("FirstDnsInvalid");
        return false;
    }
	
    if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && Wan.IPv4SecondaryDNS != '' && (isValidIpAddress(Wan.IPv4SecondaryDNS) == false || isAbcIpAddress(Wan.IPv4SecondaryDNS) == false))
    {
        AlertMsg("SecondDnsInvalid");
        return false;
    }
    if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && (isValidIpAddress(Wan.IPv4Gateway) == false || isAbcIpAddress(Wan.IPv4Gateway) == false))
    {
         AlertMsg("WanGateWayInvalid");
         return false;
     }
     if ('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && (Wan.IPv4Gateway == Wan.IPv4IPAddress))
     {
         AlertMsg("IPAddressSameAsGateWay");
         return false;
     }
    if('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static' && false==isSameSubNet(Wan.IPv4IPAddress, Wan.IPv4SubnetMask, Wan.IPv4Gateway, Wan.IPv4SubnetMask))
    {
        AlertMsg("IPAddressNotInGateWay");
        return false;
    }
    if('1' == Wan.IPv4Enable && Wan.IPv4AddressMode == 'Static')
    {
        var addr = IpAddress2DecNum(Wan.IPv4IPAddress);
        var mask = SubnetAddress2DecNum(Wan.IPv4SubnetMask);
        var gwaddr = IpAddress2DecNum(Wan.IPv4Gateway);
        if ( (addr & (~mask)) == (~mask) )
        {
            AlertMsg("WANIPAddressInvalid");
            return false;
        }
        if ( (addr & (~mask)) == 0 )
        {
            AlertMsg("WANIPAddressInvalid");
            return false;
        }
        if ( (gwaddr & (~mask)) == (~mask) )
        {
            AlertMsg("WANGateWayIPAddressInvalid");
            return false;
        }
        if ( (gwaddr & (~mask)) == 0 )
        {
             AlertMsg("WANGateWayIPAddressInvalid");
            return false;
        }
    }
    
    if ('1' == Wan.IPv4Enable && 'Static' == Wan.IPv4AddressMode)
    {
        for (var iIP=0; iIP < GetWanList().length; iIP++)
        {
            if (GetWanList()[iIP].domain != Wan.domain && GetWanList()[iIP].IPv4IPAddress == Wan.IPv4IPAddress)
            {
                AlertMsg("IPAddressIsUserd");
                return false;
            }
        } 
    }

    if ('1' == Wan.IPv4Enable && "1" != Wan.IPv6Enable && 'PPPoE' == Wan.EncapMode)
    {
        var usr = Wan.UserName;
        var psw = Wan.Password;
        var DiaMode = Wan.IPv4DialMode;
        var Idletime = Wan.IPv4DialIdleTime;
		         
        if (DiaMode == "OnDemand")
        {
			if (false == isNum(Idletime))
			{
				AlertMsg("DiaIdleTime1");
                return false;
			}
			
            if(isNaN(Idletime) || parseInt(Idletime,10) > 86400 || parseInt(Idletime,10) < 0)
			{
				AlertMsg("DiaIdleTime1");
                return false;
			}
            
			if ( -1  !=  Idletime.indexOf("."))
			{
				AlertMsg("DiaIdleTime1");
				return false;
			}
        }
    }

	if ((Wan.UserName != '') && (isValidAscii(Wan.UserName) != ''))        
	{  
		AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + isValidAscii(Wan.UserName) + '".');          
		return false;       
	}
	
	if ((Wan.Password != '') && (isValidAscii(Wan.Password) != ''))         
	{  
		AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + isValidAscii(Wan.Password) + '".');         
		return false;       
	}

	if ('1' == Wan.IPv4Enable && "DHCP" == Wan.IPv4AddressMode)
	{
		if(Wan.IPv4VendorId.length > 64)
		{
			AlertMsg("VendorIdError");
			return false;
		}

		if ('' != isValidVenderClassID(Wan.IPv4VendorId) || '' != isValidAscii(Wan.IPv4VendorId))
		{
			AlertMsg("VendorIdInvalid");
			return false;
		}
		
		if(Wan.IPv4ClientId.length > 64)
		{
			AlertMsg("ClientIdError");
			return false;
		}

		if ('' != isValidVenderClassID(Wan.IPv4ClientId) || '' != isValidAscii(Wan.IPv4ClientId))
		{
			AlertMsg("ClientIdInvalid");
			return false;
		}
	}
	
	if (Wan.IPv6Enable == "1" && Wan.IPv6PrefixMode == "Static")
	{
	    if (Wan.IPv6StaticPrefix.length == 0)
	    {
	        AlertMsg("IPv6PrefixEmpty");
	        return false;
	    }

	    var List = Wan.IPv6StaticPrefix.split("/");
	    if (List.length != 2)
	    {
	        AlertMsg("IPv6PrefixInvalid");
	        return false;
	    }
		if ('' == List[1])
		{
	        AlertMsg("IPv6PrefixInvalid");
	        return false;
	    }

	    if ( List[1].length > 1 && List[1].charAt(0) == '0' )
      {
         AlertMsg("IPv6PrefixInvalid");
         return false;  
      }
	    if (parseInt(List[1],10) < 1 || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) > 64)
	    {
            	AlertMsg("IPv6PrefixInvalid");
            	return false;    
	    }

	    if (IsIPv6AddressValid(List[0]) == false)
	    {
            	AlertMsg("IPv6PrefixInvalid");
            	return false;  
	    }

	    if ( IsIPv6ZeroAddress(List[0]) == true)
	    {
            	AlertMsg("IPv6PrefixInvalid");
            	return false;  
	    } 

	    if (parseInt(List[0].split(":")[0], 16) >= parseInt("0xFF00", 16))
            {
                AlertMsg("IPv6PrefixInvalid");
                return false;   
            } 
	}
	
	if (Wan.IPv6Enable == "1" && Wan.IPv6AddressMode == "AutoConfigured" && Wan.IPv6AddressStuff.length > 0)
	{
	    var List = Wan.IPv6AddressStuff.split("/");
	    if (List.length != 2)
	    {
	        AlertMsg("IPv6PrefixMaskInvalid");
	        return false;   
	    }
	    if ( List[1].length > 1 && List[1].charAt(0) == '0' )
     {
         AlertMsg("IPv6PrefixMaskInvalid");
         return false;  
     }
	    if (parseInt(List[1],10) < 1  || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) != 64)
	    {
                AlertMsg("IPv6PrefixMaskInvalid");
                return false;    
	    }
	    if (IsIPv6AddressValid(List[0]) == false)
	    {
                AlertMsg("IPv6PrefixMaskInvalid");
                return false;  
	    } 

	}

    if (Wan.IPv6Enable == "1" && Wan.IPv6AddressMode == "Static")
    {
        if (Wan.IPv6IPAddress.length == 0)
        {
            AlertMsg("IPv6AddressEmpty");
            return false;
        }

        if (IsIPv6AddressValid(Wan.IPv6IPAddress) == false)
        {
            AlertMsg("IPv6AddressInvalid");
            return false;  
        }

        if (parseInt(Wan.IPv6IPAddress.split(":")[0], 16) >= parseInt("0xFF00", 16))
        {
            AlertMsg("IPv6AddressInvalid");
            return false;   
        } 

        if (IsIPv6ZeroAddress(Wan.IPv6IPAddress) == true)
        {
           AlertMsg("IPv6AddressInvalid");
           return false;  
        }

        if (IsIPv6LoopBackAddress(Wan.IPv6IPAddress) == true)
        {
            AlertMsg("IPv6AddressInvalid");
            return false;    
        }
        
        if(Wan.IPv6GatewayE8c.length > 0)
        {
        	if (IsIPv6AddressValid(Wan.IPv6GatewayE8c) == false)
        	{
              AlertMsg("IPv6AddressInvalid2");
              return false;  
        	}

        	if (parseInt(Wan.IPv6GatewayE8c.split(":")[0], 16) >= parseInt("0xFF00", 16))
        	{
              AlertMsg("IPv6AddressInvalid2");
              return false;   
        	}
        	 
        	if (IsIPv6ZeroAddress(Wan.IPv6GatewayE8c) == true)
            {
               AlertMsg("IPv6AddressInvalid2");
               return false;  
            }

        	if (IsIPv6LoopBackAddress(Wan.IPv6GatewayE8c) == true)
        	{
              AlertMsg("IPv6AddressInvalid2");
              return false;    
        	}
			
			if(Wan.IPv6GatewayE8c == Wan.IPv6IPAddress)
			{
				AlertMsg("IPAddressSameAsGateWay2");
				return false;
			}
			if(false == IsIPv6LinkLocalAddress(Wan.IPv6GatewayE8c) && false == isSameIPv6SubNet(Wan.IPv6IPAddress,Wan.IPv6GatewayE8c,Wan.IPv6AddrMaskLenE8c))
			{
				AlertMsg("IPAddressNotInGateWay2");
				return false;
			}
        }
        

        if (Wan.IPv6PrimaryDNS.length)
        {
			if ( IsIPv6AddressValid(Wan.IPv6PrimaryDNS) == false)
			{
				AlertMsg("IPv6FirstDnsInvalid");
				return false;
                        }
            
			if (parseInt(Wan.IPv6PrimaryDNS.split(":")[0], 16) >= parseInt("0xFF00", 16))
			{
			    AlertMsg("IPv6FirstDnsInvalid");
			    return false;   
			} 

			if (IsIPv6ZeroAddress(Wan.IPv6PrimaryDNS) == true)
			{
			   AlertMsg("IPv6FirstDnsInvalid");
			   return false;  
			}

			if (IsIPv6LoopBackAddress(Wan.IPv6PrimaryDNS) == true)
			{
			    AlertMsg("IPv6FirstDnsInvalid");
			    return false;    
			}

			if (IsIPv6LinkLocalAddress(Wan.IPv6PrimaryDNS) == true || IsIPv6SiteLocalAddress(Wan.IPv6PrimaryDNS) == true)
			{
			    AlertMsg("IPv6FirstDnsInvalid");
			    return false;    
			} 			
			
        }

        if (Wan.IPv6SecondaryDNS.length > 0)
        {
			if ( IsIPv6AddressValid(Wan.IPv6SecondaryDNS) == false)
			{
				AlertMsg("IPv6SecondDnsInvalid");
				return false;
                        }
            
			if (parseInt(Wan.IPv6SecondaryDNS.split(":")[0], 16) >= parseInt("0xFF00", 16))
			{
			    AlertMsg("IPv6SecondDnsInvalid");
			    return false;   
			} 

			if (IsIPv6ZeroAddress(Wan.IPv6SecondaryDNS) == true)
			{
			   AlertMsg("IPv6SecondDnsInvalid");
			   return false;  
			}

			if (IsIPv6LoopBackAddress(Wan.IPv6SecondaryDNS) == true)
			{
			    AlertMsg("IPv6SecondDnsInvalid");
			    return false;    
			} 

			if (IsIPv6LinkLocalAddress(Wan.IPv6SecondaryDNS) == true || IsIPv6SiteLocalAddress(Wan.IPv6SecondaryDNS) == true)
			{
			    AlertMsg("IPv6SecondDnsInvalid");
			    return false;    
			}        
            
        }
    }
	
	if ((Wan.IPv6Enable == "1") && (Wan.EncapMode.toString().toUpperCase() == "IPOE") && (Wan.IPv6AddressMode == "None"))
	{
		if (Wan.IPv6ReserveAddress.length > 0)
		{
			if (IsIPv6AddressValid(Wan.IPv6ReserveAddress) == false)
			{
				AlertMsg("IPv6AddressInvalid");
				return false;  
			}
	
		}
	}

	if(Wan.IPv6Enable == 0)
	{
		if ((false == isNum(Wan.IPv4MXU)) || isNaN(Wan.IPv4MXU) || parseInt(Wan.IPv4MXU,10) > 1540 || parseInt(Wan.IPv4MXU,10) < 1)
		{
	   		AlertMsg("IPv4MxuAlert");
			return false;
		}
		
		if ( Wan.IPv4MXU.length > 1 && Wan.IPv4MXU.charAt(0) == '0' )
		{
	 		 AlertMsg("IPv4MxuAlert1");
		     return false;
		}
	}
	else
	{
		if(Wan.IPv6DSLite.toString() == "Off")
		{
			if (false == isNum(Wan.IPv4MXU) || isNaN(Wan.IPv4MXU) || parseInt(Wan.IPv4MXU,10) > 1540 || parseInt(Wan.IPv4MXU,10) < 1280)
			{
				AlertMsg("IPv6MxuAlert");
				return false;
			}
			
			if ( Wan.IPv4MXU.length > 1 && Wan.IPv4MXU.charAt(0) == '0' )
			{
				 AlertMsg("IPv4MxuAlert1");
				 return false;
		    }
		}
	}
	
	if (false == CheckDSLite(Wan))
	{
		return false;
	}
	
	if (false == Check6rd(Wan))
	{
		return false;
	}
	
    return true;
}

function CheckDSLite(Wan)
{
    DomainElement = Wan.domain.split(".");
	wanCurrentInst = DomainElement[4];
    if (Wan.ProtocolType.toString() != "IPv6" )
	{
	    return true;
	}
	if (Wan.Mode.toString().toUpperCase() != "IP_ROUTED" )
	{
	    return true;
	}

	for (i = 0;i < GetWanList().length;i++)
	{
	    DBDomainElement = GetWanList()[i].domain.split(".");
	    wanDBInst = DBDomainElement[4];
	    if( GetWanList()[i].IPv6DSLite.toString() != "Off" )
		{
			if((Wan.IPv6DSLite.toString() != "Off") && (wanDBInst != wanCurrentInst))
			{
			    AlertMsg("DSLiteNumError");
				return false;
			}
		}
	}
	if (Wan.IPv6DSLite.toString() == "Static" )
	{
		if (trim(Wan.IPv6AFTRName).length == 0)
		{
			AlertMsg("AFTRNameErr2");
			return false;
	    }
		
		if (isValidAscii(Wan.IPv6AFTRName) != '')         
		{  
			AlertEx(Languages['AFTRName1'] + Languages['Hasvalidch'] + isValidAscii(Wan.IPv6AFTRName) + '".');          
			return false;       
		}
		
	    if(!((Wan.IPv6AFTRName.length > 0) && (Wan.IPv6AFTRName.length < 257)))
		{
		    AlertMsg("AFTRNameErr");
			return false;
		}
	}

	return true;
}

function Check6rd(Wan)
{
    DomainElement = Wan.domain.split(".");
	wanCurrentInst = DomainElement[4];
	
	if (true != Is6RdSupported())
	{
		return true;
	}
	
    if (Wan.ProtocolType.toString() != "IPv4" )
	{
	    return true;
	}
	if (Wan.Mode.toString().toUpperCase() != "IP_ROUTED" )
	{
	    return true;
	}

	if ("STATIC" == Wan.RdMode.toString().toUpperCase())
	{
		if ((Wan.RdPrefix.length == 0) || (IsIPv6AddressValid(Wan.RdPrefix) == false)
		 ||(parseInt(Wan.RdPrefix.split(":")[0], 16) >= parseInt("0xFF00", 16))
		 ||(IsIPv6ZeroAddress(Wan.RdPrefix) == true)
		 ||(IsIPv6LoopBackAddress(Wan.RdPrefix) == true))
        {
            AlertMsg("RdPrefixInvalid");
            return false;
        }
		
		if (false == CheckNumber(Wan.RdPrefixLen, 10, 64))
		{
			AlertMsg("RdPrefixLenthInvalid");
			return false;
	    }					
				
		if((isValidIpAddress(Wan.RdBRIPv4Address) == false) || (isAbcIpAddress(Wan.RdBRIPv4Address) == false))
		{
			AlertMsg("RdBrAddrInvalid");
            return false;
		}
		
		if (false == CheckNumber(Wan.RdIPv4MaskLen, 0, 32))
		{
			AlertMsg("RdIPv4MaskLenInvalid");
			return false;
	    }
		
		if ((parseInt(Wan.RdPrefixLen,10) - parseInt(Wan.RdIPv4MaskLen,10)) > 32)
		{
			AlertMsg("RdPreLenAndV4MaskLenMismatch");
			return false;
		}		
	}
	
	return true;
}


function isInvalidRadionString(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch == "," || ch == ";" || ch == "'" || ch == "\"" )
        {
            return ch;
        }
    }

    return '';
}

function CheckRadioString(str)
{
    var c = isValidAscii(str);
    if(c != '')
    {
        return c;
    }
    
    c = isInvalidRadionString(str);
    if(c != '')
    {
        return c;
    }     
    
    return '';
}

function CheckRadioWan(Wan, EditFlag)
{
	if (false == IsCurrentRadioWan())
	{
		return true;
	}
	
	if (EditFlag == "ADD")
	{
	    var wanListTmp = GetWanList();
		var maxCnt = 1;
		var tmpCnt = 0;
		
		for (var i=0; i < wanListTmp.length; i++ )
		{
			if (wanListTmp[i].Name.indexOf(RADIOWAN_NAMEPREFIX) >= 0)
			{
				tmpCnt++;
			}
			
			if (tmpCnt >= maxCnt)
			{
				AlertMsg("RadioWanIsFull");
				return false;
			}
		}
	}
	
	if (Wan.SwitchDelayTime == "")
    {
		AlertMsg("SwitchDelayTimeisreq");
        return false;
    }  

	var SwitchDelayTime = removeSpaceTrim(Wan.SwitchDelayTime);
	if(SwitchDelayTime!="")
	{
		if ( false == CheckNumber(SwitchDelayTime,3, 3600) )
		{
			AlertMsg("invalidSwitchDelayTime");
			return false;
		}
	}
	
	if ( Wan.PingIPAddress != '' && (isValidIpAddress(Wan.PingIPAddress) == false || isAbcIpAddress(Wan.PingIPAddress) == false))
    {
         AlertMsg("invalidipaddr");
         return false;
    }

	if ((Wan.RadioWanUsername != '') && (CheckRadioString(Wan.RadioWanUsername) != ''))        
	{  
		AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + CheckRadioString(Wan.RadioWanUsername) + '".');          
		return false;       
	}
	
	if ((Wan.RadioWanPassword != '') && (Wan.RadioWanPassword != radio_hidepassword) && (CheckRadioString(Wan.RadioWanPassword) != ''))         
	{  
		AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + CheckRadioString(Wan.RadioWanPassword) + '".');         
		return false;       
	}
	
	if ((Wan.APN != '') && (CheckRadioString(Wan.APN) != ''))         
	{  
		AlertEx(Languages['APN1'] + Languages['Hasvalidch'] + CheckRadioString(Wan.APN) + '".');         
		return false;       
	}
	
	if (('' != Wan.RadioWanUsername) || ('' != CheckRadioString(Wan.RadioWanUsername)))
	{
		if (false == ConfirmEx(Languages['RadioWanNotSupportUsername']))
		{
			return false;
		}		
	}
	
	return true;
}
