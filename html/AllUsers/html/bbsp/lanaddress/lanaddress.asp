<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html"; charset="utf-8">
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>

<script language="javascript" src="../common/userinfo.asp"></script>
<script language="javascript" src="../common/topoinfo.asp"></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/wanaddressacquire.asp"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/<%HW_WEB_CleanCache_Resource(page.html);%>"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<style>
.SelectDdns{
	width: 260px;
}
.InputDdns{
	width: 254px;
}
</style>
<script>
    function Br0IPv6AddressClass(domain, Alias, IPv6Address)
    {
        this.domain = domain;
        this.Alias = Alias;
        this.IPv6Address = IPv6Address;
    }

    function Br0IPv6PrefixClass(domain, Alias, ParentPrefix, ChildPrefixMask, Mode, Prefix, PreferredLifeTime, ValidLifeTime)
    { 
        this.domain = domain;
        this.Alias = Alias;
        this.ParentPrefix = ParentPrefix;
        this.ChildPrefixMask = ChildPrefixMask;
		
		switch(Mode.toString().toUpperCase())
		{
			case "WANDELEGATED": 
				Mode = "WANDelegated"; break;
			case "HGWPROXY": 
				Mode = "HGWProxy"; break;
			case "STATIC": 
				Mode = "Static"; break;
			default: 
				break;
		}
        this.Mode = Mode;
        this.Prefix = Prefix;
        this.PreferredLifeTime = PreferredLifeTime;
        this.ValidLifeTime = ValidLifeTime;     
    }
    function IPv6DNSConfigClass(domain, DomainName, IPv6DNSConfigType, IPv6DNSWANConnection, IPv6DNSServers)
    { 
        this.domain = domain;
        this.DomainName = DomainName;
        this.IPv6DNSConfigType = IPv6DNSConfigType;
        this.IPv6DNSWANConnection = IPv6DNSWANConnection;
        this.IPv6DNSServers = IPv6DNSServers;
    }

    function IPv6BindLanClass(domain, LanInterface)
    { 
        this.domain = domain;
        this.LanInterface = LanInterface;
    }

    function RaConfigInfoClass(domain, ManagedFlag, OtherConfigFlag, mode, Enable, MTU)
    {
        this.domain = domain;
        this.ManagedFlag = ManagedFlag;
        this.OtherConfigFlag = OtherConfigFlag;
        this.Mode = mode;
		    this.Enable = Enable;
		    this.MTU = MTU;
    }

    function UlaModeInfoClass(domain, ULAmode)
    {
        this.domain = domain;
        this.ULAmode = ULAmode;
    }

	function DhcpV6Server(domain, Enable)
    {
        this.domain = domain;
        this.Enable= Enable;
    }
	
    function UlaConfigInfoClass(domain, ULAPrefix, ULAPrefixLen, ValidLifetime, PreferredLifetime)
    {
        this.domain = domain;
        this.ULAPrefix = ULAPrefix;
		this.ULAPrefixLen = ULAPrefixLen;
		this.ValidLifetime = ValidLifetime;
		this.PreferredLifetime = PreferredLifetime;
    }

 	var DhcpV6SEnable = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server, Enable, DhcpV6Server);%>;  
	var DhcpV6ServerTemp = DhcpV6SEnable[0];
     
    var Temp1 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetBr0Ipv6Address, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.IPv6Address.{i},Alias|IPv6Address, Br0IPv6AddressClass);%>;
    var Br0IPv6Address = Temp1[0];

    var Temp2 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetIPv6Prefix,InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.IPv6Prefix.{i},Alias|ParentPrefix|ChildPrefixMask|Mode|Prefix|PreferredLifeTime|ValidLifeTime, Br0IPv6PrefixClass);%>;
    var Br0IPv6Prefix = Temp2[0];

    var Temp3 =  <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1, LanInterface, IPv6BindLanClass);%>;  
    var LanInterface = Temp3[0];

    var Temp4 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetRaConfig, InternetGatewayDevice.LANDevice.1.X_HW_RouterAdvertisement, ManagedFlag|OtherConfigFlag|mode|Enable|MTU, RaConfigInfoClass);%>;  
    var RaConfig = Temp4[0];
	
	var Temp5 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetUlaMode, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.ULAIPv6Prefix, ULAmode, UlaModeInfoClass);%>;  
    var UlaMode = Temp5[0];
	
    var Temp6 = <%HW_WEB_GetSpecParaArryByDomain(HW_WEB_GetUlaPrefix, InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.ULAIPv6Prefix.prefix.{i}, ULAPrefix|ULAPrefixLen|ValidLifetime|PreferredLifetime, UlaConfigInfoClass);%>;  
    var DefaultUla = new UlaConfigInfoClass("","fd00::1","64","7200","3600");
    var UlaConfig = (Temp6.length==1)?DefaultUla:Temp6[0];
    var Temp7 = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.X_HW_IPv6Config,DomainName|IPv6DNSConfigType|IPv6DNSWANConnection|IPv6DNSServers, IPv6DNSConfigClass);%>;
    var IPv6DNSConfig = Temp7[0];
    </script>
<script>
	function IsSupportUlaCfg()
	{
		if(!isE8cAndCMCC())
		{
			return true;
		}
		
		return false;
	}
	
function isWanname(domain)
{
	if((null != domain) && (undefined != domain))
	{
		var domaina = domain.split('.'); 
		if(domaina[3] == null || undefined == domaina[3])
			return  true
		else
			return false;
	}
}

function IsValidWan(Wan)
{
    if (Wan.Mode != "IP_Routed")
    {
        return false;
    }

    if (Wan.IPv6Enable == "0")
    {
        return false;
    }

    return true;
}
 
var wan_domain = "";   
function IsinWanList(domain)
{

    var WanList = GetWanListByFilter(IsValidWan);
    var i = 0;
    
    for (i = 0; i < WanList.length; i++)
    {        
        if( domain == WanList[i].domain || domain == domainTowanname(WanList[i].domain)) 
        {
            wan_domain =  WanList[i].domain;
            return true;
        }
    }  
    return false;
    
}

	function SetDisplayULAConfig(sh)
	{
		setDisplay("UlaPrefixDEFHIDERow",sh);
		setDisplay("ULAPrefixLenDEFHIDERow",sh);
		setDisplay("UlaPreferredLifetimeDEFHIDERow",sh);
		setDisplay("UlaValidLifetimeDEFHIDERow",sh);
	}

    function BindPageData()
    {
        setText("IPv6Address", Br0IPv6Address.IPv6Address);		
        setText("Prefix", Br0IPv6Prefix.Prefix);
        setText("PreferredLifeTime", ((Br0IPv6Prefix.PreferredLifeTime == 0) ? 3600 : Br0IPv6Prefix.PreferredLifeTime));
        setText("ValidLifeTime", ((Br0IPv6Prefix.ValidLifeTime == 0) ? 7200 : Br0IPv6Prefix.ValidLifeTime));
        setSelect("PreFixModeList", Br0IPv6Prefix.Mode);
        setSelect("WanNameList", Br0IPv6Prefix.ParentPrefix);
        setText("SubPrefixMask", Br0IPv6Prefix.ChildPrefixMask);
        setSelect("ResourceAllocModeList", RaConfig.Mode);

        if (('SONET' != CfgModeWord.toUpperCase()) && ('JAPAN8045D' != CfgModeWord.toUpperCase()))
        {
            setText("RAMXUCol", RaConfig.MTU);	
        }
        if (('SONET' == CfgModeWord.toUpperCase()) || ('JAPAN8045D' == CfgModeWord.toUpperCase())) 
        {
            var EnableDhcpv6 = DhcpV6ServerTemp.Enable;
            setCheck("EnablePrefixAssignment", RaConfig.Enable); 	
            setCheck("EnableDHCPv6Server", EnableDhcpv6); 
        }
		
        if (RaConfig.Mode == "Manual")
        {
            setRadio("AssignType", RaConfig.ManagedFlag);
            setRadio("OtherType", RaConfig.OtherConfigFlag);    
            setDisplay("AssignTypeRow", 1);  
			setDisplay("OtherTypeRow", 1);
        }
        else
        {
            setRadio("AssignType", RaConfig.ManagedFlag);
            setRadio("OtherType", RaConfig.OtherConfigFlag); 
            setDisplay("AssignTypeRow", 0);  
			setDisplay("OtherTypeRow", 0);  
        }
        
        setSelect("Ipv6landnsList", IPv6DNSConfig.IPv6DNSConfigType);   
        
        
        if(IsinWanList(IPv6DNSConfig.IPv6DNSWANConnection))  
        {                      
        	setSelect("Ipv6wanname", wan_domain);
        }

        
        var Ipv6DnsServer = IPv6DNSConfig.IPv6DNSServers.split(",");       
        setText("Ipv6PrimaryDNS", ((Ipv6DnsServer.length >= 1) ? Ipv6DnsServer[0] : ""));
        setText("Ipv6secondDNS", ((Ipv6DnsServer.length >= 2) ? Ipv6DnsServer[1] : ""));
		
		if (IsSupportUlaCfg() == true)
		{
			if ("" == UlaMode)
			{
				setDisplay("ULAmodeDEFHIDERow",0);
				setDisplay("UlaTipsTitleDEFHIDE",0);	
				setDisplay("UlaInfoSpace",0);
				SetDisplayULAConfig(0);					
			}
			else
			{
				setSelect("ULAmodeDEFHIDE",UlaMode.ULAmode);
				setDisplay("ULAmodeDEFHIDERow",1);
				setDisplay("UlaTipsTitleDEFHIDE",1);	
				setDisplay("UlaInfoSpace",1);
				SetDisplayULAConfig(1);	
			}
			
			if ("" == UlaConfig)
			{
				setText("UlaPrefixDEFHIDE", "");		
				setText("ULAPrefixLenDEFHIDE", "");		
				setText("UlaPreferredLifetimeDEFHIDE", "");	
				setText("UlaValidLifetimeDEFHIDE", "");
			}
			
			if (("" != UlaMode) && ("" != UlaConfig))
			{
				setSelect("ULAmodeDEFHIDE",UlaMode.ULAmode);
				setText("UlaPrefixDEFHIDE", UlaConfig.ULAPrefix);		
				setText("ULAPrefixLenDEFHIDE", UlaConfig.ULAPrefixLen);		
				setText("UlaPreferredLifetimeDEFHIDE", UlaConfig.PreferredLifetime);	
				setText("UlaValidLifetimeDEFHIDE", UlaConfig.ValidLifetime);	

				if (0 == RaConfig.ManagedFlag)
				{
					setDisplay("ULAmodeDEFHIDERow",1);
					setDisplay("UlaTipsTitleDEFHIDE",1);	
					setDisplay("UlaInfoSpace",1);
					
					if ("MANUAL" == UlaMode.ULAmode.toUpperCase()) 
					{
						SetDisplayULAConfig(1);
					}
					else
					{
						SetDisplayULAConfig(0);
					}
				}
				else
				{
					setDisplay("ULAmodeDEFHIDERow",0);
					setDisplay("UlaTipsTitleDEFHIDE",0);
					setDisplay("UlaInfoSpace",0);	
					SetDisplayULAConfig(0);	
				}
			}
		}
	   Ipv6landnsSelect(IPv6DNSConfig.IPv6DNSConfigType);
	   PreFixModeSelect(Br0IPv6Prefix.Mode);
		
        var LanInterfaceList = LanInterface.LanInterface.split(",");
        for (var i = 0; i < LanInterfaceList.length; i++)
        {
            setCheck(LanInterfaceList[i].toUpperCase(), "1");	
        }
        return true;
    
    }

	function AddPrefixInstance()
	{
		if(UlaConfig.domain != '')
		{	
			return ;
		}
		var Onttoken = getValue('onttoken');
		
		$.ajax({
		type : "POST",
		async : false,
		cache : false,
		data : 'o.ULAPrefix=' + UlaConfig.ULAPrefix + '&o.ULAPrefixLen=' + UlaConfig.ULAPrefixLen 
		       + '&o.PreferredLifetime=' + UlaConfig.PreferredLifetime + '&o.ValidLifetime=' + UlaConfig.ValidLifetime + '&x.X_HW_Token=' + Onttoken,
		url :  'add.cgi?o=InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.ULAIPv6Prefix.prefix'
		       + '&RequestFile=html/ipv6/not_find_file.asp',
		error:function(XMLHttpRequest, textStatus, errorThrown) 
		{
			if(XMLHttpRequest.status == 404)
			{
				UlaConfig.domain = 'InternetGatewayDevice.LANDevice.1.LANHostConfigManagement.X_HW_IPv6Interface.1.ULAIPv6Prefix.prefix.1';
			}
		}
		});	
	}
	
    function OnPageLoad()
    {
        BindPageData();
				if(IsSonetUser())
				{
					setDisplay("InterfaceAddrInfoForm",0);  
				}
		
	    if(('SONET' != CfgModeWord.toUpperCase()) && ('JAPAN8045D' != CfgModeWord.toUpperCase()))
		{
			setDisplay("EnablePrefixAssignmentRow",0);			
			setDisplay("EnableDHCPv6ServerRow",0);	
		}
		
		if(('SONET' == CfgModeWord.toUpperCase()) || ('JAPAN8045D' == CfgModeWord.toUpperCase()))
		{
		  setDisplay("RAMXUColRow",0);
		}
        return true;
    }
    
    function CheckTimeValue(PreferredTime, VaildTime)
    {
    	PreferredTime = removeSpaceTrim(PreferredTime);
	if(PreferredTime!="")
	{
	   if ( false == CheckNumber(PreferredTime, 600, 4294967295) )
	   {
			AlertEx(lan_address_language['bbsp_preferredtimeinvaild']);
			return false;
	   }
	}
	else
	{
		AlertEx(lan_address_language['bbsp_preferredtimereq']);
		return false;
	}

	VaildTime = removeSpaceTrim(VaildTime);
	
	if(VaildTime!="")
	{
	   if ( false == CheckNumber(VaildTime, 600, 4294967295) )
	   {
			AlertEx(lan_address_language['bbsp_vaildtimeinvaild']);
			return false;
	   }
	}
	else
	{
		AlertEx(lan_address_language['bbsp_vaildtimereq']);
		return false;
	}

	if (parseInt(VaildTime, 10) < parseInt(PreferredTime, 10))
	{
		AlertEx(lan_address_language['bbsp_vaildtimereqvalue']);
		return false; 
	}
	
	return true;
    }

    function CheckIpAddPrefix(Ipv6AddPrefix)
    {
            if (Ipv6AddPrefix.length == 0)
	    {
	        AlertEx(Languages['IPv6PrefixEmpty']);
	        return false;
	    }
	    var List = Ipv6AddPrefix.split("/");
	    if (List.length != 2)
	    {
	        AlertEx(Languages['IPv6PrefixInvalid']);
	        return false;
	    }
	    if ('' == List[1])
	    {
	        AlertEx(Languages['IPv6PrefixInvalid']);
	        return false;
	    }
	    if ( List[1].length > 1 && List[1].charAt(0) == '0' )
	    {
	         AlertEx(Languages['IPv6PrefixInvalid']);
	         return false;  
	    }
	    if (parseInt(List[1],10) < 1 || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) > 64)
	    {
            	AlertEx(Languages['IPv6PrefixInvalid']);
            	return false;    
	    }
	    if (IsIPv6AddressValid(List[0]) == false)
	    {
            	AlertEx(Languages['IPv6PrefixInvalid']);
            	return false;  
	    }
	    if ( IsIPv6ZeroAddress(List[0]) == true)
	    {
            	AlertEx(Languages['IPv6PrefixInvalid']);
            	return false;  
	    } 
	    if (parseInt(List[0].split(":")[0], 16) >= parseInt("0xFF00", 16))
            {
                AlertEx(Languages['IPv6PrefixInvalid']);
                return false;   
            }  
    }
    
    function CheckParameter()
    { 
		var IPAddress = getValue("IPv6Address");
		var WANName = getSelectVal("Ipv6wanname");
		var DNSSourceMode = getSelectVal("Ipv6landnsList");
		var IpPrimaryDNS = getValue("Ipv6PrimaryDNS");
		var IpsecondDNS = getValue("Ipv6secondDNS");
		var RAMXU = getValue("RAMXUCol");
		
		if (RAMXU == '' || (false == isNum(RAMXU)) || isNaN(RAMXU) || parseInt(RAMXU,10) > 1500 || parseInt(RAMXU,10) < 1280)
		{
			if (('SONET' != CfgModeWord.toUpperCase())&&('JAPAN8045D' != CfgModeWord.toUpperCase())){
	   		AlertEx(Languages['RAMxuAlert']);
			  return false;
		  }
		}
		if((DNSSourceMode.toUpperCase() == "WANCONNECTION") && (WANName == "") )
		{
			AlertEx(lan_address_language['bbsp_selectwan']);
			return false;
		}
		if(DNSSourceMode.toUpperCase() == "STATIC")
		{
			if(IpPrimaryDNS.length == 0 && IpsecondDNS.length == 0)
			{
				AlertEx(lan_address_language['bbsp_ipv6isreq']);
				return false;
			}
			
			if(IpPrimaryDNS.length != 0)
			{
				if (IsIPv6AddressValid(IpPrimaryDNS) == false)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;
				}
				if (IsIPv6MulticastAddress(IpPrimaryDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;  
				} 
				if (IsIPv6ZeroAddress(IpPrimaryDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;
				}
				if (IsIPv6LoopBackAddress(IpPrimaryDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;  
				}
			}
			
			if(IpsecondDNS.length != 0)
			{
				if (IsIPv6AddressValid(IpsecondDNS) == false)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;
				}
				if (IsIPv6MulticastAddress(IpsecondDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;  
				} 
				if (IsIPv6ZeroAddress(IpsecondDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;
				}
				if (IsIPv6LoopBackAddress(IpsecondDNS) == true)
				{
					AlertEx(lan_address_language['bbsp_ipv6invalid']);
					return false;  
				}
			}
		}
		
		if(false == IsSonetUser())
		{
			if (IPAddress.length == 0)
			{
				AlertEx(lan_address_language['bbsp_ipv6isreq']);
				return false;
			}

			if (IsIPv6AddressValid(IPAddress) == false)
			{
				AlertEx(lan_address_language['bbsp_ipv6invalid']);
				return false;
			}

			if (IsIPv6MulticastAddress(IPAddress) == true)
			{
				AlertEx(lan_address_language['bbsp_ipv6invalid']);
				return false;  
			} 

			if (IsIPv6ZeroAddress(IPAddress) == true)
			{
				AlertEx(lan_address_language['bbsp_ipv6invalid']);
				return false;
			}

			if (IsIPv6LoopBackAddress(IPAddress) == true)
			{
				AlertEx(lan_address_language['bbsp_ipv6invalid']);
				return false;  
			}

			if(getValue("SubPrefixMask").length == 0)
			{
				AlertEx(lan_address_language['bbsp_premaskisreq']);
				return false;  
			}

			var List = getValue("SubPrefixMask").split("/");
			if (List.length != 2)
			{
				AlertEx(lan_address_language['bbsp_premaskinvalid']);
				return false;   
			}
			if (parseInt(List[1],10) < 1 || isNaN(List[1].replace(' ', 'a')) == true || parseInt(List[1],10) != 64)
			{
				AlertEx(lan_address_language['bbsp_premaskinvalid']);
				return false;    
			}
			if (IsIPv6AddressValid(List[0]) == false)
			{
				AlertEx(lan_address_language['bbsp_premaskinvalid']);
				return false;  
			} 
		}
		if (IsSupportUlaCfg() == true)
		{
			var PrefixAssignType = getRadioVal('AssignType');
			var UlaMode = getValue('ULAmodeDEFHIDE');
			var UlaPrefix = getValue('UlaPrefixDEFHIDE');
			var UlaPrefixLen = getValue('ULAPrefixLenDEFHIDE');
			var UlaPreferredTime = getValue('UlaPreferredLifetimeDEFHIDE');
			var UlaVaildTime = getValue('UlaValidLifetimeDEFHIDE');
						
			if (0 == PrefixAssignType)
			{
				if ("MANUAL" == UlaMode.toUpperCase()) 
				{
					if (UlaPrefix.length == 0)
					{
						AlertEx(lan_address_language['bbsp_prefixisreq']);
						return false;
					}
					
					if (IsIPv6AddressValid(UlaPrefix) == false)
					{
						AlertEx(lan_address_language['bbsp_ipv6invalid']);
						return false;
					}
					
					if (IsIPv6UlaAddress(UlaPrefix) == false)
					{
						AlertEx(lan_address_language['bbsp_prefixinvaild']);
						return false;  
					} 
					
					UlaPrefixLen = removeSpaceTrim(UlaPrefixLen);
					if(UlaPrefixLen!="")
					{
					   if ( false == CheckNumber(UlaPrefixLen, 16, 64) )
					   {
							AlertEx(lan_address_language['bbsp_prefixlengthinvaild']);
							return false;
					   }
					}
					else
					{
						AlertEx(lan_address_language['bbsp_prefixlenisreq']);
						return false;
					}
					
					UlaPreferredTime = removeSpaceTrim(UlaPreferredTime);
					if(UlaPreferredTime!="")
					{
					   if ( false == CheckNumber(UlaPreferredTime, 600, 4294967295) )
					   {
							AlertEx(lan_address_language['bbsp_preferredtimeinvaild']);
							return false;
					   }
					}
					else
					{
						AlertEx(lan_address_language['bbsp_preferredtimereq']);
						return false;
					}

					UlaVaildTime = removeSpaceTrim(UlaVaildTime);
					if(UlaVaildTime!="")
					{
					   if ( false == CheckNumber(UlaVaildTime, 600, 4294967295) )
					   {
							AlertEx(lan_address_language['bbsp_vaildtimeinvaild']);
							return false;
					   }
					}
					else
					{
						AlertEx(lan_address_language['bbsp_vaildtimereq']);
						return false;
					}

					if (parseInt(UlaVaildTime, 10) < parseInt(UlaPreferredTime, 10))
					{
						AlertEx(lan_address_language['bbsp_vaildtimereqvalue']);
						return false; 
					}
				}
			}
		}
		
		
	var Ipv6PrefixMode = getSelectVal("PreFixModeList");

	if ("STATIC" == Ipv6PrefixMode.toUpperCase() && false == IsSonetUser()) 
	{

		var Ipv6AddPrefix = getValue("Prefix");
		if (false == CheckIpAddPrefix(Ipv6AddPrefix))
		{
			return false;
		}	
		var Ipv6PreferredLifeTime = getValue("PreferredLifeTime");
		var Ipv6ValidLifeTime = getValue("ValidLifeTime");
			
		if (false == CheckTimeValue(Ipv6PreferredLifeTime, Ipv6ValidLifeTime))
		{
			return false;
		}	
	}
	
        return true;     
    }
	
    function GetLanList()
    {
        var List = "";
        for (var i = 1; i <=4; i++)
        {
            if (getCheckVal("LAN"+i) == 1)
            {
             		List += "LAN"+i +",";
            }
            if (getCheckVal("SSID"+i) == 1)
            {
             		List += "SSID"+i +",";
            }
        }
        if (List.length > 0)
        {
         		List = List.substr(0, List.length-1);
        }
         
        return List;
     }
     function GetIpv6WanDnsServerString(PrimaryDnsServer, SecondaryDnsServer)
	{
		var DnsServerString = "";
		if ("" != PrimaryDnsServer && "" != SecondaryDnsServer)
		{
			DnsServerString = PrimaryDnsServer + "," + SecondaryDnsServer;
		}
		else
		{
			DnsServerString = PrimaryDnsServer  + SecondaryDnsServer;
		}
		return DnsServerString;
	}

    function OnApplyButtonClick()
    {
        if (CheckParameter() == false)
        {
            return false;
        }
        if(IsSupportUlaCfg() == true)
        {
       	 	AddPrefixInstance();
		}
		
        var url = "";
        var Form = new webSubmitForm();
		if(false == IsSonetUser())
		{
			Form.addParameter('x.IPv6Address', getValue("IPv6Address"));
			Form.addParameter('y.Prefix', getValue("Prefix"));
			Form.addParameter('y.PreferredLifeTime', getValue("PreferredLifeTime"));
			Form.addParameter('y.ValidLifeTime', getValue("ValidLifeTime"));
			Form.addParameter('y.Mode', getSelectVal("PreFixModeList"));
			Form.addParameter('y.ParentPrefix',getSelectVal("WanNameList"));
			Form.addParameter('y.ChildPrefixMask',getValue("SubPrefixMask"));
		}
		if (('SONET' != CfgModeWord.toUpperCase()) && ('JAPAN8045D' != CfgModeWord.toUpperCase()))
		{
			Form.addParameter('m.MTU',getValue("RAMXUCol"));
        }
        Form.addParameter('z.LanInterface',GetLanList());
        Form.addParameter('m.mode',getSelectVal("ResourceAllocModeList"));
		
        if ( "Manual" == getSelectVal("ResourceAllocModeList"))
        {
            Form.addParameter('m.ManagedFlag',getRadioVal("AssignType"));
            Form.addParameter('m.OtherConfigFlag',getRadioVal("OtherType"));
        }
		
        if (('SONET' == CfgModeWord.toUpperCase()) || ('JAPAN8045D' == CfgModeWord.toUpperCase()))
        {        
            var PAEnable = getCheckVal("EnablePrefixAssignment");
            var DHCPv6ServerEnable = getCheckVal("EnableDHCPv6Server");
            
			Form.addParameter('m.Enable',PAEnable);
			Form.addParameter('r.Enable',DHCPv6ServerEnable);
        }
        else
        {
 			Form.addParameter('m.Enable',1);
        }
		
        Form.addParameter('p.IPv6DNSConfigType',getSelectVal("Ipv6landnsList"));
        Form.addParameter('p.IPv6DNSWANConnection',getSelectVal("Ipv6wanname")); 
        Form.addParameter('p.IPv6DNSServers',GetIpv6WanDnsServerString(getValue("Ipv6PrimaryDNS"), getValue("Ipv6secondDNS")));

		url = 'x='+Br0IPv6Address.domain+"&y="+Br0IPv6Prefix.domain +"&z="+LanInterface.domain+ "&p="+IPv6DNSConfig.domain+ "&m=InternetGatewayDevice.LANDevice.1.X_HW_RouterAdvertisement";
		if (('SONET' == CfgModeWord.toUpperCase()) || ('JAPAN8045D' == CfgModeWord.toUpperCase()))
		{
			url += "&r=InternetGatewayDevice.LANDevice.1.X_HW_DHCPv6.Server";
		}
		
		if (IsSupportUlaCfg() == true)
		{
			if (0 == getRadioVal('AssignType')) 
			{
				Form.addParameter('n.ULAmode', getValue('ULAmodeDEFHIDE'));
				url += "&n="+UlaMode.domain;
				if ("MANUAL" == getValue('ULAmodeDEFHIDE').toUpperCase()) 
				{	
					var UlaPrefixLen = getValue('ULAPrefixLenDEFHIDE');
					UlaPrefixLen = removeSpaceTrim(UlaPrefixLen);
					var UlaPreferredTime = getValue('UlaPreferredLifetimeDEFHIDE');
					UlaPreferredTime = removeSpaceTrim(UlaPreferredTime);
					var UlaVaildTime = getValue('UlaValidLifetimeDEFHIDE');
					UlaVaildTime = removeSpaceTrim(UlaVaildTime);

					Form.addParameter('o.ULAPrefix', getValue('UlaPrefixDEFHIDE'));
					Form.addParameter('o.ULAPrefixLen', UlaPrefixLen);
					Form.addParameter('o.PreferredLifetime', UlaPreferredTime);
					Form.addParameter('o.ValidLifetime', UlaVaildTime);
					url += "&o="+UlaConfig.domain;					
				}
			}
		}
		
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		
		if(getValue("IPv6Address").toUpperCase()!=(Br0IPv6Address.IPv6Address).toUpperCase())
		{
			if(ConfirmEx(lan_address_language['bbsp_note']))
			{
			 	Form.setAction('set.cgi?' + url + '&RequestFile=html/logout.html');
			}
			else
			{
				return false;
			}
		}
		else
		{
			Form.setAction('set.cgi?' + url + '&RequestFile=html/bbsp/lanaddress/lanaddress.asp');
		}
		
        Form.submit();
		
        setDisable('ButtonApply',1);
    	setDisable('ButtonCancel',1);
        return false;
    }

    function OnCancelButtonClick()
    {       
        BindPageData();
        return false;
    }
	
	function ulaSelect(val)
	{
		var UlaMode = val.value;
		if ("MANUAL" == UlaMode.toUpperCase()) 
		{
			SetDisplayULAConfig(1);
			if ("" == getValue("UlaPrefixDEFHIDE"))
			{
				setText("UlaPrefixDEFHIDE", "fd00::1");	
			}
			
			if ("" == getValue("ULAPrefixLenDEFHIDE"))
			{
				setText("ULAPrefixLenDEFHIDE", "16");	
			}
			
			if ("" == getValue("UlaPreferredLifetimeDEFHIDE"))
			{
				setText("UlaPreferredLifetimeDEFHIDE", "3600");
			}
			
			if ("" == getValue("UlaValidLifetimeDEFHIDE"))
			{
				setText("UlaValidLifetimeDEFHIDE", "7200");
			}
		}
		else
		{
			SetDisplayULAConfig(0);
		}
	}
	
	function ResouceAllocSelect()
	{
		var resourceallocmode = getValue("ResourceAllocModeList");
	    if (resourceallocmode == "Manual")
	    {
	        setDisplay("AssignTypeRow", 1);  
	        setDisplay("OtherTypeRow", 1);  
	    }
	    else
	    {
	        setDisplay("AssignTypeRow", 0);  
	        setDisplay("OtherTypeRow", 0);  
	    }
	}
	
	function PreFixModeSelect()
	{
	    var  PreFixModeValue =  getValue("PreFixModeList");
		if ("STATIC" == PreFixModeValue.toUpperCase()) 
		{
			setDisplay("PrefixRow", 1);  
			setDisplay("PreferredLifeTimeRow", 1);
			setDisplay("ValidLifeTimeRow", 1);
			setDisplay("WanNameListRow", 0);
			setDisplay("SubPrefixMaskRow", 0);		
		}
		else
		{
		    setDisplay("PrefixRow", 0);  
			setDisplay("PreferredLifeTimeRow", 0);
			setDisplay("ValidLifeTimeRow", 0);
			setDisplay("WanNameListRow", 1);
			setDisplay("SubPrefixMaskRow", 1);
		}		
	}
	
	function Ipv6landnsSelect(val)
	{
		var Ipv6landns = getValue("Ipv6landnsList");
		if ("WANCONNECTION" == Ipv6landns.toUpperCase()) 
		{	
			setDisplay("Ipv6wannameRow",1);
			setDisplay("Ipv6PrimaryDNSRow", 0);
			setDisplay("Ipv6secondDNSRow", 0);
			
		}
		else if ("STATIC" == Ipv6landns.toUpperCase()) 
		{
			
			setDisplay("Ipv6PrimaryDNSRow", 1);
		    setDisplay("Ipv6secondDNSRow", 1);
		    setDisplay("Ipv6wannameRow", 0);
				
			if ("FE80::1" == getValue("Ipv6PrimaryDNS").toUpperCase() && "STATIC" != IPv6DNSConfig.IPv6DNSConfigType.toUpperCase())
		    {
				setText("Ipv6PrimaryDNS", "");
		    }
		}
		else
		{
			setDisplay("Ipv6PrimaryDNSRow", 0);
		    setDisplay("Ipv6secondDNSRow", 0);
		    setDisplay("Ipv6wannameRow", 0);
		}		
	}

	function ChangePrefixCfgMode()
	{
		if (IsSupportUlaCfg() == true)
		{
			if ("" != UlaMode)
			{
				setSelect("ULAmodeDEFHIDE",UlaMode.ULAmode);
				
				if (0 == getRadioVal('AssignType')) 
				{
					setDisplay("ULAmodeDEFHIDERow",1);
					setDisplay("UlaTipsTitleDEFHIDE",1);	
					setDisplay("UlaInfoSpace",1);
					
					if ("MANUAL" == UlaMode.ULAmode.toUpperCase()) 
					{
						SetDisplayULAConfig(1);
					}
					else
					{
						SetDisplayULAConfig(0);
					}
				}
				else
				{			
					setDisplay("ULAmodeDEFHIDERow",0);
					setDisplay("UlaTipsTitleDEFHIDE",0);	
					setDisplay("UlaInfoSpace",0);
					SetDisplayULAConfig(0);
				}
			}
		}
	}
	
    function ControlLanList(LanIdPrefix, SSIDPrefix)
    {
        for (var i = 1; i <= parseInt(TopoInfo.EthNum,10); i++)
        {
            if (IsL3Mode(i) == "0")
            {
                setDisable(LanIdPrefix+i, 1);
            }
        }

        for (var i = parseInt(TopoInfo.EthNum,10)+1; i <= 4; i++)
        {
            setDisplay(LanIdPrefix+i, 0);
        }

        for (var i = parseInt(TopoInfo.SSIDNum,10)+1; i <= 4; i++)
        {
            setDisplay(SSIDPrefix+i, 0);
        }
    }
	
</script>
<title>TODO:XXX Configuration</title>
</head>
<body  class="mainbody" onload="OnPageLoad();"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("lanaddress", GetDescFormArrayById(lan_address_language, "bbsp_mune"), GetDescFormArrayById(lan_address_language, "bbsp_lan_address_title"), false);
</script>
<div class="title_spread"></div>

<form id="InterfaceAddrInfoForm" name="InterfaceAddrInfoForm">
<div id="IPv6AddresInfoPanel" class="func_title" BindText="bbsp_ipv6addressinfo"></div>
<table id="InterfaceAddrInfoFormPanel" border="0" cellpadding="0" cellspacing="1"  width="100%"> 
<li id="IPv6Address" RealType="TextBox" DescRef="bbsp_ipv6mh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="x.IPv6Address" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="PreFixModeList" RealType="DropDownList" DescRef="bbsp_Ipv6PrefixMode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="PreFixModeList" Elementclass="SelectDdns" InitValue="[{TextRef:'bbsp_WANDelegated',Value:'WANDelegated'},{TextRef:'bbsp_Static',Value:'Static'}]" ClickFuncApp="onchange=PreFixModeSelect" />
<li id="Prefix" RealType="TextBox" DescRef="bbsp_ipv6Prefixmh" RemarkRef="" ErrorMsgRef="Empty" Require="TRUE" BindField="y.Prefix" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="PreferredLifeTime" RealType="TextBox" DescRef="bbsp_ipv6PreferredLifeTimemh" RemarkRef="bbsp_preferredtimenoteE8c" ErrorMsgRef="Empty" Require="TRUE" BindField="PreferredLifeTime" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="ValidLifeTime" RealType="TextBox" DescRef="bbsp_ipv6ValidLifeTimemh" RemarkRef="bbsp_vaildtimenoteE8c" ErrorMsgRef="Empty" Require="TRUE" BindField="ValidLifeTime" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="WanNameList" RealType="DropDownList" DescRef="bbsp_parentPremh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="WanNameList" Elementclass="SelectDdns" InitValue="Empty" />
<li id="SubPrefixMask" RealType="TextBox" DescRef="bbsp_childpremh" RemarkRef="bbsp_lanaddressnote" ErrorMsgRef="Empty" Require="TRUE" BindField="SubPrefixMask" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="RAMXUCol" RealType="TextBox" DescRef="bbsp_mtu" RemarkRef="bbsp_mturemark" ErrorMsgRef="Empty" Require="TRUE" BindField="RAMXUCol" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
</table>
<script>
	var TableClass = new stTableClass("table_title align_left width_per25", "table_right align_left width_per75");
	var InterfaceAddrInfoFormList = new Array();
	InterfaceAddrInfoFormList = HWGetLiIdListByForm("InterfaceAddrInfoForm",null);
	HWParsePageControlByID("InterfaceAddrInfoForm",TableClass,lan_address_language,null);
</script>	
<script>getElById("SubPrefixMask").title = Languages['AddressStuffTitle'];</script>
<script> document.getElementById("PrefixRemark").innerHTML = Languages['PrefixRemark'];</script>
<div class="func_spread"></div>
</form>
	
<form id="DnsInfoForm" name="DnsInfoForm">
<div id="DnsInfoTitle" class="func_title" BindText="bbsp_ipv6dnsserverinfo"></div>
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li id="Ipv6landnsList" RealType="DropDownList" DescRef="bbsp_Ipv6landnsMode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Ipv6landnsList" Elementclass="SelectDdns" InitValue="[{TextRef:'bbsp_HGWDNSProxy',Value:'HGWProxy'},{TextRef:'bbsp_WANConnection',Value:'WANConnection'},{TextRef:'bbsp_StaticDNS',Value:'Static'}]" ClickFuncApp="onchange=Ipv6landnsSelect"/>
<li id="Ipv6wanname" RealType="DropDownList" DescRef="bbsp_Ipv6wanname" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty" Elementclass="SelectDdns" InitValue="Empty" />
<li id="Ipv6PrimaryDNS" RealType="TextBox" DescRef="bbsp_Ipv6PrimaryDNS" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Ipv6PrimaryDNS" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="Ipv6secondDNS" RealType="TextBox" DescRef="bbsp_Ipv6secondDNS" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Ipv6secondDNS" Elementclass="InputDdns" MaxLength="255"  InitValue="Empty" />
</table>
<script>
	var TableClassTwo = new stTableClass("table_title align_left width_per25", "table_right align_left width_per75");
	var DnsInfoFormList = new Array();
	DnsInfoFormList = HWGetLiIdListByForm("DnsInfoForm",null);
	HWParsePageControlByID("DnsInfoForm",TableClassTwo,lan_address_language,null);
</script>
</form>

<form id="ResourceAllocationForm" name="ResourceAllocationForm">
<div class="func_spread"></div>
<div id="ResourceAllocTitle" class="func_title" BindText="bbsp_resourceallocinfo"></div>
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li id="EnablePrefixAssignment" RealType="CheckBox" DescRef="bbsp_enableRAmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="EnablePrefixAssignment" InitValue="Empty" />
<li id="EnableDHCPv6Server" RealType="CheckBox" DescRef="bbsp_enableDHCP6Smh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="EnableDHCPv6Server" InitValue="Empty" />
<li id="ResourceAllocModeList" RealType="DropDownList" DescRef="bbsp_resourceallocmode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="m.mode" Elementclass="SelectDdns" InitValue="[{TextRef:'bbsp_manualconfigure',Value:'Manual'},{TextRef:'bbsp_autoconfigure',Value:'Auto'}]" ClickFuncApp="onchange=ResouceAllocSelect" />
<li id="AssignType" RealType="RadioButtonList" DescRef="bbsp_prefixcfgmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="AssignType"     InitValue="[{TextRef:'bbsp_dhcp',Value:'1'},{TextRef:'bbsp_slaac',Value:'0'}]" ClickFuncApp="onclick=ChangePrefixCfgMode"/>
<li id="OtherType" RealType="RadioButtonList" DescRef="bbsp_othercfgmh" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="m.OtherConfigFlag"     InitValue="[{TextRef:'bbsp_dhcp',Value:'1'},{TextRef:'bbsp_slaac',Value:'0'}]"/>
</table>
<script>
	var ResourceAllocationFormList = new Array();
	ResourceAllocationFormList = HWGetLiIdListByForm("ResourceAllocationForm",null);
	HWParsePageControlByID("ResourceAllocationForm",TableClassTwo,lan_address_language,null);
</script>
</form>

<form id="UlaInfoForm" name="UlaInfoForm">
<div id="UlaInfoSpace" class="func_spread"></div>
<div id="UlaTipsTitleDEFHIDE" class="func_title" BindText="bbsp_ulainfo">
</div>
<table border="0" cellpadding="0" cellspacing="1"  width="100%">
<li id="ULAmodeDEFHIDE" RealType="DropDownList" DescRef="bbsp_ulamode" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="ULAmodeDEFHIDE" Elementclass="SelectDdns" InitValue="[{TextRef:'bbsp_disable',Value:'Disable'},{TextRef:'bbsp_manualconfigure',Value:'Manual'},{TextRef:'bbsp_autoconfigure',Value:'Auto'}]" ClickFuncApp="onchange=ulaSelect"/>
<li id="UlaPrefixDEFHIDE" RealType="TextBox" DescRef="bbsp_prefix" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE" BindField="UlaPrefixDEFHIDE" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="ULAPrefixLenDEFHIDE" RealType="TextBox" DescRef="bbsp_prefixlength" RemarkRef="bbsp_prefixlengthnote" ErrorMsgRef="Empty" Require="TRUE" BindField="ULAPrefixLenDEFHIDE" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="UlaPreferredLifetimeDEFHIDE" RealType="TextBox" DescRef="bbsp_preferredtime" RemarkRef="bbsp_preferredtimenote" ErrorMsgRef="Empty" Require="TRUE" BindField="UlaPreferredLifetimeDEFHIDE" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="UlaValidLifetimeDEFHIDE" RealType="TextBox" DescRef="bbsp_vaildtime" RemarkRef="bbsp_vaildtimenote" ErrorMsgRef="Empty" Require="TRUE" BindField="UlaValidLifetimeDEFHIDE" Elementclass="InputDdns" MaxLength="255" InitValue="Empty" />
<li id="SpanLANDEFHIDE"           RealType="CheckBoxList"       DescRef="bbsp_assginportmh"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.SpanLAN" InitValue="[{TextRef:'bbsp_LAN1',Value:'bbsp_LAN1'},{TextRef:'bbsp_LAN2',Value:'bbsp_LAN2'},{TextRef:'bbsp_LAN3',Value:'bbsp_LAN3'},{TextRef:'bbsp_LAN4',Value:'bbsp_LAN4'},{TextRef:'bbsp_SSID1',Value:'bbsp_SSID1'},{TextRef:'bbsp_SSID2',Value:'bbsp_SSID2'},{TextRef:'bbsp_SSID3',Value:'bbsp_SSID3'},{TextRef:'bbsp_SSID4',Value:'bbsp_SSID4'}]"/>  
</table>
<script>
	var UlaInfoFormList = new Array();
	UlaInfoFormList = HWGetLiIdListByForm("UlaInfoForm",null);
	HWParsePageControlByID("UlaInfoForm",TableClassTwo,lan_address_language,null);
</script>
</form>
	
  <table id="ConfigPanelButtons" width="100%"  cellspacing="1" class="table_button"> 
    <tr>
      <td class='width_per25'> </td> 
      <td class="table_submit pad_left5p"> <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input class="ApplyButtoncss buttonwidth_100px" name="ButtonApply" id= "ButtonApply" type="button" BindText="bbsp_app" onClick="javascript:return OnApplyButtonClick();"> 
	  <input class="CancleButtonCss buttonwidth_100px" name="ButtonCancel" id="ButtonCancel" type="button" BindText="bbsp_cancel" onClick="javascript:OnCancelButtonClick();"></td> 
    </tr> 
  </table> 
  <div style="height:10px;"></div>

<script>
ParseBindTextByTagName(lan_address_language, "td",    1);
ParseBindTextByTagName(lan_address_language, "div",   1);

InitWanNameListControl("WanNameList", IsValidWan);    
InitWanNameListControl1("Ipv6wanname", IsValidWan);

ControlLanList("SpanLAN", "SpanSSID");
ParseBindTextByTagName(lan_address_language, "input", 2);
</script> 
</body>
</html>
