var CurrentWan = null;
var EditFlag = "";
var ChangeUISource = "";
var AddType     = 1;
var CurrentWan = new WanInfoInst();
var defaultWan  = new WanInfoInst(); 
var COMPLEX_CGI_PREFIX='Add_';
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';      
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var DoubleFreqFlag = <%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>;
var curUserType='<%HW_WEB_GetUserType();%>';  
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>";
var CUVoiceFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_UNICOM_DIS_VOICE);%>";
var DisliteFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_BTV_WAN_PROTOCOL_IGNORE);%>";
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

function IsCurrentRadioWan()
{
	var Wan = GetCurrentWan();
	var AccessTtpe = Wan.AccessType;

	if (("1" == RadioWanFeature) && ('0' == AccessTtpe))
	{
		return true;
	}
	return false;
} 

function getInstIdByDomain(domain)
{
    if ('' != domain)
    {
        return parseInt(domain.charAt(domain.length - 1));    
    }
}

function getWlanPortNumber(name)
{
    if ('' != name)
    {
        return parseInt(name.charAt(name.length - 1));    
    }
}

function stWlan(domain, Name, ssid, X_HW_RFBand)
{
    this.domain = domain;
    this.Name = Name;
    this.ssid = ssid;
    this.X_HW_RFBand = X_HW_RFBand;
    this.WlanInst = getInstIdByDomain(domain);
}
if (1 == DoubleFreqFlag )
{     
    var WlanListTotal = new Array();
    WlanListTotal = '<%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i}, Name|SSID|X_HW_RFBand, stWlan);%>';
    if (WlanListTotal.length > 0) 
	{
		WlanListTotal = eval(WlanListTotal);
	}
	else
	{
		WlanListTotal = new Array(null);
	}
    var WlanListNum = WlanListTotal.length - 1;       
	for (var i = 0; i < WlanListNum; i++)
    {
       for (var j = i; j < WlanListNum; j++)
       {
			var index_i = getWlanPortNumber(WlanListTotal[i].Name);
			var index_j = getWlanPortNumber(WlanListTotal[j].Name);
			
			if (index_i > index_j)
			{
				var WlanTemp = WlanListTotal[i];
				WlanListTotal[i] = WlanListTotal[j];
				WlanListTotal[j] = WlanTemp;
			}
		}
	}
}

function SetCurrentWan(Wan)
{
    CurrentWan = Wan;
}
function GetCurrentWan()
{
    if (CurrentWan != null)
    {
        return CurrentWan;
    }
    
    return GetPageData();
}
function IsConTrigCanBeSend(Wan)
{
    if (Wan.Mode.toString().toUpperCase() == 'IP_ROUTED' && Wan.ServiceList.toString().toUpperCase() == 'INTERNET') 
    {
        return true;
    } 
    
    return false;
}


function GetOriginalWan(Domain)
{
	var WanList = GetWanList();
	
	for (var i = 0; i < WanList.length; i++)
	{
		if (WanList[i].domain == Domain)
		{
			return WanList[i];
		}
	}

	return null;
}

function IsConnectionTypeChange()
{
	var CurrentWan = GetCurrentWan();
	var OriginalWan = GetOriginalWan(CurrentWan.domain);
	if (OriginalWan == null)
	{
		return true;
	}

	var CurrentType = (CurrentWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? "BRIDGE" : "ROUTE";
	var OriginalType = (OriginalWan.Mode.toUpperCase().indexOf("BRIDGE") >= 0) ? "BRIDGE" : "ROUTE";

	return (CurrentType == OriginalType) ? false : true;
}

function IsOriginalTr069Type()
{
	var CurrentWan = GetCurrentWan();
	var OriginalWan = GetOriginalWan(CurrentWan.domain);
	if (OriginalWan == null)
	{
		return false;
	}

	return (OriginalWan.ServiceList.toUpperCase().indexOf("TR069") >= 0) ? true : false;
}


function ControlSpec()
{
    setDisplay("WanDomainRow", 0);
    setDisplay("IPv6SubnetMaskRow", 0);
    setDisplay("IPv6DefaultGatewayRow", 0); 
     
    var FeatureInfo = GetFeatureInfo(); 
    if (FeatureInfo.IPv6 == "0")
    {
        
        setDisplay("WanIPv4InfoBarRow", 0);
        setDisplay("WanIPv6InfoBarRow", 0);
        setDisplay("IPv6PrefixModeRow", 0);
        setDisplay("IPv6StaticPrefixRow", 0);
        setDisplay("IPv6AddressModeRow", 0);
        setDisplay("IPv6AddressStuffRow", 0);   
        setDisplay("IPv6IPAddressRow", 0);
        setDisplay("IPv6AddrMaskLenE8cRow", 0);
        setDisplay("IPv6GatewayE8cRow", 0);
		setDisplay("IPv6ReserveAddress", 0);
        setDisplay("IPv6SubnetMaskRow", 0);
        setDisplay("IPv6DefaultGatewayRow", 0);
        setDisplay("IPv6PrimaryDNSServerRow", 0);
        setDisplay("IPv6SecondaryDNSServerRow", 0);  
        setDisplay("IPv6WanMVlanIdRow", 0);     
        setDisable("ProtocolType", 1);
        setSelect("ProtocolType", "IPv4");

    }
    if (FeatureInfo.WanPriPolicy == "0")
    {
        setDisplay("PriorityPolicyRow", 0);
    }
}

function ControlPanel()
{
    var Wan = GetCurrentWan();
    var Type = Wan.ProtocolType.toString();
    var IPv4BarIndex = 0;
    var IPv6BarIndex = 0;
    

    setDisplay("WanIPv4InfoBarPanel", 0);
    setDisplay("WanIPv6InfoBarPanel", 0);
   
   if(false == IsRDSGatewayUser())
   {
	    if (Type.toUpperCase()=="IPV4")
	    {
	        setDisplay("WanIPv4InfoBarPanel", 1);
	    }
    
	    if (Type.toUpperCase()=="IPV6")
	    {
	        setDisplay("WanIPv6InfoBarPanel", 1);
	    }
    
        if (Type.toUpperCase()=="IPV4/IPV6")
        {
	        setDisplay("WanIPv4InfoBarPanel", 1);
	        setDisplay("WanIPv6InfoBarPanel", 1);
	    }
		
		if (true == IsCurrentRadioWan())
		{
			setDisplay("WanIPv4InfoBarPanel", 0);
			setDisplay("WanIPv6InfoBarPanel", 0);
		}
    }
    
}

function ControlDislite()
{
    var Wan = GetCurrentWan();
   
   if(false == IsRDSGatewayUser())
   {
	    if ((Wan.IPv6DSLite=="Dynamic")
		    ||(Wan.IPv6DSLite=="Static"))
	    {
		    setDisplay("WanIPv4InfoBarPanel", 1);
	        setDisplay("WanIPv4InfoBarRow", 1);
			setDisplay("IPv4WanMVlanIdRow",1);
			setDisplay("IPv4AddressModeRow", 0);
		    setDisplay("IPv4NatSwitchRow", 0);
		    setDisplay("IPv4NatTypeRow", 0);
		    setDisplay("IPv4VendorIdRow", 0);
		    setDisplay("IPv4ClientIdRow", 0);
			setDisplay("IPv4ClientIdRow", 0);
	    }
    }
    
}


function ControlIPv4AddressMode()
{
    setDisplay("IPv4AddressModeRow", 1);
    if (GetCurrentWan().Mode.toString().toUpperCase() != "IP_ROUTED")
    {
        setDisplay("IPv4AddressModeRow", 0);
    }

}

function ControlIPv4DHCPEnable()
{
    var ServiceList = GetCurrentWan().ServiceList.toString().toUpperCase();
	var Wan = GetCurrentWan();
    var src = getElementById('ServiceList');
    
    setDisplay("LanDhcpSwitchRow", 0);
    if ( ServiceList.match('INTERNET') || ServiceList.match('IPTV') || ServiceList.match('OTHER') )
    {
        if(isE8cAndCMCC())
        {
	        setDisplay("LanDhcpSwitchRow", 1);
	    }
    }

    if(('JSCMCC' == CfgModeWord.toUpperCase()) && (getElementById('VlanId').value == 4031) && (curUserType == 0) && IsWanHidden(domainTowanname(Wan.domain)) == true)
    {
        setDisable("LanDhcpSwitch", 1);
    }
	else
	{
		setDisable("LanDhcpSwitch", 0);
	}
	
    if(EditFlag.toUpperCase() == "ADD" && ChangeUISource == src)
    {
        if (ServiceList == "OTHER")
	    {
            setCheck("LanDhcpSwitch", 0);
        }
	    else
	    {
	        setCheck("LanDhcpSwitch", 1);
	    }
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("LanDhcpSwitchRow", 0);
	}
}

function IsDstIPForwardingListVisibility(Wan,ServiceList)
{
  var CurrentBin = '<%HW_WEB_GetBinMode();%>';
	if (   (ServiceList == "TR069")
	     ||(ServiceList == "VOIP")
	     ||(ServiceList == "TR069_VOIP")
	     ||("IP_BRIDGED" == Wan.Mode.toString().toUpperCase()) 
	     ||("PPPOE_BRIDGED" == Wan.Mode.toString().toUpperCase()))
	{
		return false;
	}
	if ('E8C' != CurrentBin.toUpperCase())
	{
		return false;
	}
	return true;
}

function ControlDstIPForwardingListVisibility()
{
	var Wan = GetCurrentWan();
	var ServiceList = Wan.ServiceList;
	
	setDisplay("DstIPForwardingListRow", 1);
	setDisplay("DstIPForwardingList", 1);
	
	if (( false == IsDstIPForwardingListVisibility(Wan,ServiceList) )||(true == IsCurrentRadioWan()))
	{
		setDisplay("DstIPForwardingListRow", 0);
		setDisplay("DstIPForwardingList", 0);
	}
}

function setWirelessDisplay(flag)
{
	setDisplay("RadioWanPSEnableRow", flag);
	setDisplay("SwitchModeRow", flag);
	setDisplay("SwitchDelayTimeRow", flag);
	setDisplay("PingIPAddressRow", flag);
	setDisplay("DialInfoBarRow", flag);
	setDisplay("RadioWanUsernameRow", flag);
	setDisplay("RadioWanPasswordRow", flag);
	setDisplay("APNRow", flag);
	setDisplay("DialNumberRow", flag);

	if(productName.indexOf("5676")>=0)
	{
		setDisplay("TriggerModeRow", 0);
	}
	else
	{
		setDisplay("TriggerModeRow", flag);
	}
	
	setDisplay("ServiceListRow", flag);
}

function setPonDisplay(flag)
{
	setDisplay("WanSwitchRow", flag);
	setDisplay("EncapModeRow", flag);
	setDisplay("ProtocolTypeRow", flag);	
	setDisplay("WanModeRow", flag);	
	setDisplay("ServiceListRow", flag);
	setDisplay("VlanSwitchRow", flag);
}

function CntrolAccessType()
{
	if (("1" == RadioWanFeature))	
	{
		setDisplay("AccessTypeRow", 1);
	}
	else
	{
		setDisplay("AccessTypeRow", 0);
	}
}

function ControlRadioWan()
{
	if (true == IsCurrentRadioWan())
	{
		setPonDisplay(0);
        setWirelessDisplay(1);
        RemoveServiceListVoipForLte("RADIO");
	}
	else
	{
		setWirelessDisplay(0);
		setPonDisplay(1);
        RemoveServiceListVoipForLte("PON");
	}
}


function displayWanMode()
{
	var wanMode = getElementById('WanMode');
	if(bin5board() == true) 
	{
		RemoveItemFromSelect(wanMode, 'IP_Bridged');
	}
}

function displayProtocolType()
{
	var protoType = getElementById('ProtocolType');
	var IPProtVer = GetIPProtVerMode();
	var Feature = GetFeatureInfo();

	if ((bin5board() == true) 
	 || ((EditFlag.toUpperCase() == "ADD") && (Feature.IPProtChk == 1) && (IPProtVer == 1)))
	{
		RemoveItemFromSelect(protoType, Languages['IPv4IPv6']);
		RemoveItemFromSelect(protoType, Languages['IPv6']);
	}
	else if ((EditFlag.toUpperCase() == "ADD") && (Feature.IPProtChk == 1) && (IPProtVer == 2))
	{
		RemoveItemFromSelect(protoType, Languages['IPv4IPv6']);
		RemoveItemFromSelect(protoType, Languages['IPv4']);
	}
}

function displaysvrlist() 
{
	if (EditFlag.toUpperCase() == "ADD")
	{
		Controlsvrlist();
	}
}


function ControlIPv4MXU()
{
    var WanProtocolType = GetCurrentWan().ProtocolType.toString();
    var WanIPv6DSLite = GetCurrentWan().IPv6DSLite.toString();
    var MXURemarkStr = "";
	
    if (GetCurrentWan().EncapMode.toString().toUpperCase() == "PPPOE")
    {
        document.getElementById("IPv4MXURow").cells[0].innerHTML = Languages['IPv4MRU'];
    }
    else
    {
        document.getElementById("IPv4MXURow").cells[0].innerHTML = Languages['IPv4MXU'];
    }
    
    setDisplay("IPv4MXURow", 1);
	
	if ((GetCurrentWan().Mode.toString().toUpperCase() != "IP_ROUTED") 
		|| (GetCfgMode().PCCWHK == "1") || (true == IsCurrentRadioWan()))
	{
		setDisplay("IPv4MXURow", 0);
	}
    
    if (WanProtocolType.match("IPv6"))
    {
		
		MXURemarkStr = ("ARABIC" == LoginRequestLanguage.toUpperCase()) ? "(1540-1280)" : "(1280-1540)";
		document.getElementById("IPv4MXURemark").innerHTML = MXURemarkStr;
		getElById('IPv4MXU').title = MXURemarkStr;
    }
    else
    {
		MXURemarkStr = ("ARABIC" == LoginRequestLanguage.toUpperCase()) ? "(1540-1)" : "(1-1540)";
        document.getElementById("IPv4MXURemark").innerHTML = MXURemarkStr;
		getElById('IPv4MXU').title = MXURemarkStr;
    }
}

function CheckWanSet(Wan)
{
	if(productName == 'HG8110H')
	{
		if ((Wan.ServiceList.toString().toUpperCase() != "TR069") && (Wan.ServiceList.toString().toUpperCase() != "VOIP") && (Wan.ServiceList.toString().toUpperCase() != "TR069_VOIP"))
		{
			AlertEx(Languages['CantSetInvalidSrv']);
			return false;
		}
	}
	
	return true;
}

function ControlIPv4EnableNAT()
{
    var ServiceList = GetCurrentWan().ServiceList.toString().toUpperCase();
        
    setDisplay("IPv4NatSwitchRow", 0);
    setDisplay("IPv4NatTypeRow", 0);	
    
    if (FeatureInfo.LanSsidWanBind == "0")
    {
        return;    
    }
	
    var src = getElementById('ServiceList');
    if(EditFlag.toUpperCase() == "ADD" && ChangeUISource == src)
    {
        if ( ServiceList.match('INTERNET') || ServiceList.match('IPTV') || ServiceList.match('OTHER') )
        {
            setCheck("IPv4NatSwitch", 1);
        }
        else
        {
            setCheck("IPv4NatSwitch", 0);
        }
    }
	
    if (GetCurrentWan().Mode.toString().toUpperCase().indexOf("BRIDGED") >= 0)
    {
       setCheck('IPv4NatSwitch', 1);
       return; 
    }
    
	if ('PTVDF' == CfgModeWord.toUpperCase())
	{
		if ( (ServiceList.indexOf("INTERNET") >=0 ) || (ServiceList.indexOf("IPTV") >=0) || (ServiceList.indexOf("OTHER") >=0) || (ServiceList.indexOf("VOIP") >=0))
		{
			setDisplay("IPv4NatSwitchRow", 1);
			if ("1" == GetRunningMode())
			{
				setDisplay("IPv4NatTypeRow", 0);	
			}
			else
			{
				setDisplay("IPv4NatTypeRow", 1);	
			}
			
			if (getCheckVal("IPv4NatSwitch") == "1")
			{
				setDisable("IPv4NatType", 0);   
			}
			else
			{
				setDisable("IPv4NatType", 1);
			}
		}
	}
	else
	{
		if ( (ServiceList.indexOf("INTERNET") >=0 ) || (ServiceList.indexOf("IPTV") >=0) || (ServiceList.indexOf("OTHER") >=0))
		{
			setDisplay("IPv4NatSwitchRow", 1);
			  
			if (("1" == GetCfgMode().TELMEX)
			||("1" == GetCfgMode().PCCWHK)
			||("1" == GetCfgMode().MOBILY)
			||("1" == GetRunningMode()))
			{
				setDisplay("IPv4NatTypeRow", 0);	
			}
			else
			{
				setDisplay("IPv4NatTypeRow", 1);	
			}
			
		
			if (getCheckVal("IPv4NatSwitch") == "1")
			{
				setDisable("IPv4NatType", 0);   
			}
			else
			{
				setDisable("IPv4NatType", 1);
			}
		}
		else
		{
			if (false ==IsE8cFrame())
			{
				setDisplay("IPv4NatSwitchRow", 1);
			}
		}
	}
    
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv4NatSwitchRow", 0);
		setDisplay("IPv4NatTypeRow", 0);	
	}
}


function ControlVlanId()
{
	var VlanId;
    setDisplay("VlanIdRow", 0);
    if (GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("VlanIdRow", 1);
		if (true == IsCurrentRadioWan())
		{
			 setDisplay("VlanIdRow", 0);
		}
		VlanId = GetCurrentWan().VlanId;
		if (0 == VlanId)
		{
			if (GetCurrentBin().toUpperCase() == "E8C")
			{
				setText('VlanId',1);
			}
			else
        	{
				setText('VlanId','');
			}
		}
    }
}


function ControlIPv4VendorId()
{
    setDisplay("IPv4VendorIdRow", 0);
    if (GetCurrentWan().Mode.toString().toUpperCase() == "IP_ROUTED" && GetCurrentWan().IPv4AddressMode.toString().toUpperCase() == "DHCP")
    {
        setDisplay("IPv4VendorIdRow", 1);
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv4VendorIdRow", 0);
	}
}


function ControlIPv4ClientId()
{
    setDisplay("IPv4ClientIdRow", 0);
    if ( (!isE8cAndCMCC()) && GetCurrentWan().Mode.toString().toUpperCase() == "IP_ROUTED" && GetCurrentWan().IPv4AddressMode.toString().toUpperCase() == "DHCP")
    {
        setDisplay("IPv4ClientIdRow", 1);
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv4ClientIdRow", 0);
	}
}


function ControlIPv4StaticIPAddress()
{
    var IPv4AddressType = GetCurrentWan().IPv4AddressMode.toString().toUpperCase();
    setDisplay("IPv4IPAddressRow", 0);
    setDisplay("IPv4SubnetMaskRow", 0);
    setDisplay("IPv4DefaultGatewayRow", 0);
    setDisplay("IPv4PrimaryDNSServerRow", 0);
    setDisplay("IPv4SecondaryDNSServerRow", 0);
    if (IPv4AddressType == "STATIC" && GetCurrentWan().Mode.toString().toUpperCase() == "IP_ROUTED")
    {
        setDisplay("IPv4IPAddressRow", 1);
        setDisplay("IPv4SubnetMaskRow", 1);
        setDisplay("IPv4DefaultGatewayRow", 1);
        setDisplay("IPv4PrimaryDNSServerRow", 1);
        setDisplay("IPv4SecondaryDNSServerRow", 1);
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv4IPAddressRow", 0);
		setDisplay("IPv4SubnetMaskRow", 0);
		setDisplay("IPv4DefaultGatewayRow", 0);
		setDisplay("IPv4PrimaryDNSServerRow", 0);
		setDisplay("IPv4SecondaryDNSServerRow", 0);
	}

}


function ControlUserName()
{
    var EncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();
    setDisplay("UserNameRow", 0);
    setDisplay("PasswordRow", 0);
    if (EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed")
    {
        setDisplay("UserNameRow", 1);
        setDisplay("PasswordRow", 1);
    }    
	if(CfgModeWord.toUpperCase() == 'ROSTELECOM' && curUserType != '0')
	{
		setDisable("UserName",1);
		setDisable("Password",1);
	}  
	
	if(CfgModeWord.toUpperCase() == 'NWT' && curUserType != '0')
	{
		setDisable("UserName",1);
		setDisable("Password",1);
	}  

	if(CfgModeWord.toUpperCase() == 'QTEL' && curUserType != '0')
	{
		setDisable("UserName",1);
		setDisable("Password",1);
	}  
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("UserNameRow", 0);
        setDisplay("PasswordRow", 0);
	}
}

function ControlApplyButton()
{
	var DisableButton = false; 
       var EncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();
        
	if (!IsAdminUser())
	{
		if(EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed" && CfgModeWord.toUpperCase() != 'ROSTELECOM')		
		{
			DisableButton = false;	
		}
		else
		{
			if(false == IsSonetUser())
			{
				DisableButton = true;
			}
		}

		if(EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed" && (CfgModeWord.toUpperCase() == 'NWT'))		
		{
			DisableButton = true;	
		}

		if( GetCurrentWan().ServiceList.toString().toUpperCase() =='INTERNET'
				&&  GetCfgMode().BJCU == "1" )
		{
			DisableButton = false;
		}    
		
		if(CfgModeWord.toUpperCase() == 'QTEL')
		{
			DisableButton = true;
		}

		if (true == IsCurrentRadioWan())		
		{
			DisableButton = false;
		}    
	}

       if(CfgModeWord.toUpperCase() == 'TELECOM' && IsAdminUser())
	{
		if(EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed")
		{
			DisableButton = false;
		}
		else
		{
			DisableButton = true;
		}
	}
	
	setDisable("ButtonApply", DisableButton?1:0);
	setDisable("ButtonCancel", DisableButton?1:0);
}

function ControlLcpCheck()
{
    var EncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();
    setDisplay("LcpEchoReqCheckRow", 0);
    if ((!isE8cAndCMCC()) && EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed")
    {
        setDisplay("LcpEchoReqCheckRow", 1);
    }  
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("LcpEchoReqCheckRow", 0);
	}  
}

function IPv4DialModetoManul()
{
	var Wan = GetPageData();
	if (Wan.domain.length > 10 && Wan.IPv4DialMode.toUpperCase() == "MANUAL")
	{
		var i = 0;
		for (i = 0; i < GetWanList().length; i++)
		{
			if (GetWanList()[i].domain == Wan.domain)
			{
				break;
			}
		}
		 
		if (GetWanList()[i].IPv4DialMode.toUpperCase()== "ONDEMAND" || GetWanList()[i].IPv4DialMode.toUpperCase()== "ALWAYSON")
		{
			return true;
		}
	}
	return false;
}

function ControlIPv4Dial()
{
    setDisplay("IPv4DialModeRow", 0);
    setDisplay("IPv4DialIdleTimeRow", 0);
    setDisplay("IPv4IdleDisconnectModeRow", 0);
	setDisplay("IPv4DialConnectManualRow", 0);	
    
    if (GetCurrentWan().IPv6Enable.toString().toUpperCase() == "1")
    {
        return;
    }

    if (GetCurrentWan().Mode.toString().toUpperCase() != "IP_ROUTED")
    {
        return;
    }
    
    if (GetCurrentWan().IPv4AddressMode.toString().toUpperCase() != "PPPOE")
    {
        return;
    }
    
 
    var ServiceList = GetCurrentWan().ServiceList.toString().toUpperCase();
    if (GetCfgMode().BJUNICOM == "1")
    {
        if (ServiceList != "INTERNET" && ServiceList != "OTHER")
        {
            return;
        }
    }
    else
    {
        if (ServiceList != "INTERNET")
        {
            return;
        }
    }
    
    setDisplay("IPv4DialModeRow", 1);
	
	if(GetCfgMode().BJUNICOM == "1")
	{
		document.getElementById("IPv4DialModeCol").title = Languages['IPv4DialModeDes'];
	}
	
    if (GetCurrentWan().IPv4DialMode.toString().toUpperCase() == "ONDEMAND") 
    {
        setDisplay("IPv4DialIdleTimeRow", 1); 
        setDisplay("IPv4IdleDisconnectModeRow",1);  
        
        if(GetCurrentWan().IPv4NATEnable.toString().toUpperCase() != "1")
        {
           setDisplay("IPv4IdleDisconnectModeRow",0);
        }
        if(SetIdleDisconnectMode == "1")
        {
            setDisable("IPv4IdleDisconnectMode", 1);
            setSelect("IPv4IdleDisconnectMode", "DetectUpstream");
        }
		if ("1" == supportTelmex)
		{
			setDisplay("IPv4IdleDisconnectModeRow",0);    
		}
        
    }   
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv4DialModeRow", 0);
		setDisplay("IPv4DialIdleTimeRow", 0);
		setDisplay("IPv4IdleDisconnectModeRow", 0); 
	}
	
	if(GetCurrentWan().IPv4DialMode.toString().toUpperCase() == "MANUAL" && GetCurrentWan().Enable == "1"
	&& EditFlag.toUpperCase() == "EDIT" && IPv4DialModetoManul() != true && GetCfgMode().BJUNICOM == "1")
	{
		var connectionFlag = GetCurrentWan().ConnectionControl;
		var disconnectionFlag = (connectionFlag == "0")?"1":"0";
	
		setDisable("IPv4DialConnectManual1",connectionFlag);
		setDisable("IPv4DialConnectManual2",disconnectionFlag);
		setText("IPv4DialConnectManual1",Languages['IPv4ManualConnect']); 
		setText("IPv4DialConnectManual2",Languages['IPv4ManualDisonnect']); 
		setDisplay("IPv4DialConnectManualRow", 1);
		
	} 
}

function OnConnectionButton(ControlObject)
{
	var Wan = GetCurrentWan();
	var ctrFlag = (ControlObject.id == "IPv4DialConnectManual1")?"1":"0";
	var connectionFlag = Wan.ConnectionControl;
	
	if(ctrFlag == connectionFlag)
	{
		return;
	}
	OnConnectionControlButtonCU(ControlObject,Wan.domain,ctrFlag);
}


function ControlMVlan(IPvx)
{
    var Wan = GetCurrentWan();
    setDisplay(IPvx+"WanMVlanIdRow", 1);
    
    if ( '0' == FeatureInfo.RouteWanMulticastIPoE && "IP_ROUTED" == Wan.Mode.toString().toUpperCase())
    {
        setDisplay(IPvx+"WanMVlanIdRow", 0);
        return;
    }
    if ('0' == FeatureInfo.BridgeWanMulticast && ("IP_BRIDGED" == Wan.Mode.toString().toUpperCase() || "PPPOE_BRIDGED" == Wan.Mode.toString().toUpperCase()))
    {
        setDisplay(IPvx+"WanMVlanIdRow", 0);
        return;
    } 

	if((productName == 'HG8240') && ("IP_ROUTED" == Wan.Mode.toString().toUpperCase()))
	{
		setDisplay(IPvx+"WanMVlanIdRow", 0);
		return;
	}
	
    if ((Wan.ServiceList =="TR069") || (Wan.ServiceList == "VOIP")
         || (Wan.ServiceList =="TR069_VOIP"))
    {
        setDisplay(IPvx+"WanMVlanIdRow",0);
        return;
    }
    else
    {
        setDisplay(IPvx+"WanMVlanIdRow",1);
    }

	var WanProtocolType = GetCurrentWan().ProtocolType.toString();
	var WanIPv6DSLite = GetCurrentWan().IPv6DSLite.toString();
	if (WanProtocolType == "IPv6")
	{
		if(WanIPv6DSLite != "Off")
		{
			setDisplay(IPvx+"WanMVlanIdRow", 0);
			return;
		}
		else
		{
			setDisplay(IPvx+"WanMVlanIdRow",1);
		}
	}
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay(IPvx+"WanMVlanIdRow", 0);
	}
}

function BirdgetoRoute()
{
	var Wan = GetPageData();
	if (Wan.domain.length > 10 && Wan.Mode == "IP_Routed")
	{
		var i = 0;
		for (i = 0; i < GetWanList().length; i++)
		{
			if (GetWanList()[i].domain == Wan.domain)
			{
				break;
			}
		}
		 
		if (GetWanList()[i].Mode.toUpperCase().indexOf("BRIDGE") >= 0)
		{
			return true;
		}
	}
	return false;
}

function ControlIPv4AddressType()
{
    var Wan = GetCurrentWan();
    
    setDisplay("IPv4AddressModeRow", 1);
    if (Wan.Mode.toString().toUpperCase() != "IP_ROUTED")
    {
        setDisplay("IPv4AddressModeRow", 0);
        return;
    } 
    
    setDisable("IPv4AddressMode1", 1);
    setDisable("IPv4AddressMode2", 1);
    setDisable("IPv4AddressMode3", 1); 
    
    if (Wan.EncapMode.toString().toUpperCase() == "IPOE")
    {
        setDisable("IPv4AddressMode1", 0);
        setDisable("IPv4AddressMode2", 0); 

        if ((Wan.IPv4AddressMode.toString().toUpperCase() != "STATIC")
        && (Wan.IPv4AddressMode.toString().toUpperCase() != "DHCP"))
        {
            setCheck("IPv4AddressMode2", 1);
            Wan.IPv4AddressMode = "DHCP"; 
        } 
		if((BirdgetoRoute() == true) && (Wan.IPv4AddressMode.toString().toUpperCase() == "STATIC"))
		{
			if(getElById("IPv4IPAddress").value == '0.0.0.0')
			{
				setText('IPv4IPAddress','');
			}
			if(getElById("IPv4SubnetMask").value == '0.0.0.0')
			{
				setText('IPv4SubnetMask','');
			}
			if(getElById("IPv4DefaultGateway").value == '0.0.0.0')
			{
				setText('IPv4DefaultGateway','');
			}
		}
		  
    }

    else if (Wan.EncapMode.toString().toUpperCase() == "PPPOE")
    {
        setDisable("IPv4AddressMode3", 0);
        setCheck("IPv4AddressMode3", 1);
        Wan.IPv4AddressMode = "PPPoE";
    }
}

function ControlIPv4LanWanBind()
{
    var Wan = GetCurrentWan();
    var ISPPortList = GetISPPortList();

    if (FeatureInfo.LanSsidWanBind == "0")
    {
        setDisplay('IPv4BindLanListRow',0);
        return;
    }
    
    for (var i = 1; i <= parseInt(TopoInfo.EthNum); i++)
    {
        if (IsL3Mode(i) != "1")
        {
            setDisable("IPv4BindLanList"+i, 1);
        }
    }

    if ('JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
    {
         for (var i = 1; i <= parseInt(TopoInfo.EthNum); i++)
         {
            if (IsL3Mode(i) == "1")
            {
                setDisable("IPv4BindLanList"+i, 0);
            }
        }
    }
    
    for (var i = parseInt(TopoInfo.EthNum)+1; i <= 8; i++)
    {
        setDisplay("DivIPv4BindLanList"+i, 0);
    }
	
	var UpportId = <%HW_WEB_Upportid();%>;
	if (UpportId <= 8) setDisplay("DivIPv4BindLanList"+UpportId, 0);
	
	     

	if (1 != DoubleFreqFlag)
	{
	    for (var i = parseInt(TopoInfo.SSIDNum)+9; i <= 16; i++)
    	    {
        	setDisplay("DivIPv4BindLanList"+i, 0);
    	    }
	}

	if(1 == DoubleFreqFlag)
	{
		for (var i = 0; i < WlanList.length; i++)
		{
			var tid = parseInt(i+9);
			
			if (WlanList[i].bindenable == "0")
			{  
				setDisable("IPv4BindLanList"+tid, 1);
			}
			if (WlanList[i].bindenable == "1" && 'JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
            {
                setDisable("IPv4BindLanList"+tid, 0);
            }

			for (var j = 0; j < WlanListTotal.length -1; j++)
			{
			    var WlanCapability = WlanListTotal[j].X_HW_RFBand;
			    var WlanSsid = WlanListTotal[j].ssid;
			    var WlanInst = WlanListTotal[j].WlanInst;
			    if((WlanList[i].bindenable == "1")&&(enbl5G != 1))
			    {	
                    if (-1 != WlanCapability.indexOf("5G"))			
				    {
					    setDisable("IPv4BindLanList"+(WlanInst+8), 1);
				    }
				    if (-1 == WlanCapability.indexOf("5G") && 'JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
                    {
                        setDisable("IPv4BindLanList"+(WlanInst+8), 0);
                    }
			    }
			
			    if((WlanList[i].bindenable == "1")&&(enbl2G != 1))
			    {
				    if (-1 != WlanCapability.indexOf("2.4G"))	
				    {
					    setDisable("IPv4BindLanList"+(WlanInst+8), 1);
				    }
				    if (-1 == WlanCapability.indexOf("2.4G") && 'JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
                    {
                        setDisable("IPv4BindLanList"+(WlanInst+8), 0);
                    }
				}
			}
		}
	}
	else
	{
		for (var i = 0; i < WlanList.length; i++)
		{
			var tid = parseInt(i+1+4+4);
			if (WlanList[i].bindenable == "0")
			{  
				setDisable("IPv4BindLanList"+tid, 1);
			}
			else if (WlanList[i].bindenable == "1" && 'JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
			{
			    setDisable("IPv4BindLanList"+tid, 0);
			}
		}
	}
	
	if(ISPPortList.length > 0)
    {
        for (var i = 1; i <= parseInt(TopoInfo.SSIDNum); i++)
        {
            var pos = ArrayIndexOf(ISPPortList, 'SSID'+i);
            if(pos >= 0)
            {
                var DivID = i + 4 + 4;
                setDisplay("DivIPv4BindLanList"+DivID, 0);
				if ('JSCMCC' == CfgModeWord.toUpperCase() && curUserType == 0)
                {
                    setDisplay("DivIPv4BindLanList"+DivID, 1);
                    setDisable("IPv4BindLanList"+DivID, 1);
                }
            }
        }
    }
	for (var i = 1; i <= parseInt(TopoInfo.SSIDNum); i++)
    {
        if (true == IsRDSGatewayUserSsid(i))
        {
            var DivID = i + 4 + 4;
            setDisplay("DivIPv4BindLanList"+DivID, 0);           
        }
    }
	
    setDisplay('IPv4BindLanListRow',0);
    if (Wan.ServiceList.match("INTERNET")
     || Wan.ServiceList.match("OTHER")
	 || Wan.ServiceList.match("IPTV"))
	 {
	    setDisplay('IPv4BindLanListRow',1);
	 }
        
	if (true == IsCurrentRadioWan())  
	{
		setDisplay('IPv4BindLanListRow',0);
	}
}


function ControlIPv6PrefixAcquireMode()
{
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("IPv6PrefixModeRow", 0);
    if (WanMode == "IP_ROUTED")
    {
        setDisplay("IPv6PrefixModeRow", 1);
    }   
	
	 if (true == IsCurrentRadioWan())
	 {
		 setDisplay("IPv6PrefixModeRow", 0);
	 }
}


function Control6RDParametersDisplay(Wan)
{
    var servicetypeIsMatch = (-1 != Wan.ServiceList.indexOf("INTERNET")) || (-1 != Wan.ServiceList.indexOf("IPTV")) || (-1 != Wan.ServiceList.indexOf("OTHER"));
		
    setDisplay("RDModeRow", 0); 
    setDisplay("RdPrefixRow", 0); 
    setDisplay("RdPrefixLenRow", 0); 
    setDisplay("RdBRIPv4AddressRow", 0); 
    setDisplay("RdIPv4MaskLenRow", 0);  
    
    if( (1 == Wan.IPv4Enable) && (0 == Wan.IPv6Enable) && (Wan.Mode.toString().toUpperCase() == "IP_ROUTED") &&
        (true == servicetypeIsMatch)&&(true == Is6RdSupported()) ){
		
		setDisplay("RDModeRow", 1); 
		
		if ("STATIC" == Wan.RdMode.toString().toUpperCase())
		{
			setDisplay("RdPrefixRow", 1); 
			setDisplay("RdPrefixLenRow", 1); 
			setDisplay("RdBRIPv4AddressRow",1); 
			setDisplay("RdIPv4MaskLenRow", 1); 
		}
		
		setDisableByName("RDMode", 0);
		setDisable("RdPrefix", 0);
		setDisable("RdPrefixLen", 0);
		setDisable("RdBRIPv4Address", 0);
		setDisable("RdIPv4MaskLen", 0);
		for(i = 0; i < GetWanList().length;i++)
		{
			if( GetWanList()[i].Enable6Rd != "0" && GetWanList()[i].domain != GetCurrentWan().domain)
			{
				setDisableByName("RDMode", 1);
				setDisable("RdPrefix", 1);
				setDisable("RdPrefixLen", 1);
				setDisable("RdBRIPv4Address", 1);
				setDisable("RdIPv4MaskLen", 1);
			}
		}
		
		if(Wan.IPv4AddressMode.toString().toUpperCase() != 'DHCP')
		{
			setDisable("RDMode2", 1);
		}
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("RDModeRow", 0); 
		setDisplay("RdPrefixRow", 0); 
		setDisplay("RdPrefixLenRow", 0); 
		setDisplay("RdBRIPv4AddressRow", 0); 
		setDisplay("RdIPv4MaskLenRow", 0); 
	}
}

function ControlIPv6Prefix()
{
    var IPv6StaticPrefix = GetCurrentWan().IPv6PrefixMode.toString().toUpperCase();
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("IPv6StaticPrefixRow", 0);
    if (IPv6StaticPrefix == "STATIC" && WanMode == "IP_ROUTED")
    {
        setDisplay("IPv6StaticPrefixRow", 1);
    }    
}


function ControlIPv6AddressAcquireMode()
{
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("IPv6AddressModeRow", 0);
    if (WanMode == "IP_ROUTED")
    {
        setDisplay("IPv6AddressModeRow", 1);
    }    
}


function ControlIPv6ReservedPrefixAddress()
{
	var IPv6AddressType = GetCurrentWan().IPv6AddressMode.toString().toUpperCase();
	var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
	
	setDisplay("IPv6ReserveAddressRow", 0);
	
    if(!isE8cAndCMCC())
	{
		if ((CurrentWan.EncapMode.toString().toUpperCase() == "IPOE") && (IPv6AddressType.toUpperCase() == "NONE") && (WanMode == "IP_ROUTED"))
		{
			setDisplay("IPv6ReserveAddressRow", 1);
		}
	}
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv6ReserveAddressRow", 0);
	}
}

function ControlIPv6StaticIPAddress()
{
    var IPv6AddressType = GetCurrentWan().IPv6AddressMode.toString().toUpperCase();
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();

    setDisplay("IPv6IPAddressRow", 0);
    setDisplay("IPv6AddrMaskLenE8cRow", 0);
    setDisplay("IPv6GatewayE8cRow", 0);
    setDisplay("IPv6SubnetMaskRow", 0);
    setDisplay("IPv6DefaultGatewayRow", 0);
    setDisplay("IPv6PrimaryDNSServerRow", 0);
    setDisplay("IPv6SecondaryDNSServerRow", 0);

    if (IPv6AddressType == "STATIC" && WanMode == "IP_ROUTED")
    {
        setDisplay("IPv6IPAddressRow", 1);
        setDisplay("IPv6AddrMaskLenE8cRow", 1);
        setDisplay("IPv6GatewayE8cRow", 1);
        setDisplay("IPv6SubnetMaskRow", 1);
        setDisplay("IPv6DefaultGatewayRow", 1);
        setDisplay("IPv6PrimaryDNSServerRow", 1);
        setDisplay("IPv6SecondaryDNSServerRow", 1);
    }
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv6IPAddressRow", 0);
		setDisplay("IPv6AddrMaskLenE8cRow", 0);
		setDisplay("IPv6GatewayE8cRow", 0);
		setDisplay("IPv6SubnetMaskRow", 0);
		setDisplay("IPv6DefaultGatewayRow", 0);
		setDisplay("IPv6PrimaryDNSServerRow", 0);
		setDisplay("IPv6SecondaryDNSServerRow", 0);
	}
    
}

function ControlIPv6IPAddressStuff()
{
    setDisplay("IPv6AddressStuffRow", "0");
    var IPv6AddressType = GetCurrentWan().IPv6AddressMode.toString().toUpperCase();
    var ProtocolType = GetCurrentWan().ProtocolType.toString().toUpperCase();
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    if (ProtocolType == "IPV4")
    {
        return;
    }

    if (IPv6AddressType != "AUTOCONFIGURED")
    {
        return;
    }

    if (WanMode != "IP_ROUTED")
    {
        return;
    }
    setDisplay("IPv6AddressStuffRow", "1");
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv6AddressStuffRow", "0");
	}
}

function setDisableByName(Name, Disable)
{
    var List = document.getElementsByName(Name);
    for (var i = 0; i < List.length; i++)
    {
        setDisable(List[i].id, Disable);
    }   
}

function ControlEditMode()
{
    var Disable = 0;
    var Wan = GetPageData();

    setDisableByName("EncapMode", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
	
    if (!(('SONET' == CfgModeWord.toUpperCase() || 'JAPAN8045D' == CfgModeWord.toUpperCase()) && curUserType == '0'))
	{
		setDisable("ProtocolType", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
	}
	
    setDisable("WanMode", 0);
    if((Disable) && (bin3board() == true))
    {
        setDisable("WanMode", 1);
    }
    setDisable("IPv4MXU", 0);
    setDisable("ServiceList", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
	
	if (("1" == RadioWanFeature))	
	{
		if ((EditFlag.toUpperCase() == "ADD") && (AddType == 1))
		{
			setDisable("AccessType",0);
			if ('YNCMCC' == CfgModeWord.toUpperCase())
			{
				setDisable("APN",0);
			}			
		}
		else
		{
			setDisable("AccessType",1);
			if ('YNCMCC' == CfgModeWord.toUpperCase())
			{
				setDisable("APN",1);
			}
		}
	}
    setDisableByName("IPv4AddressMode", Disable);
    setDisableByName("IPv6PrefixMode", Disable);
    setDisableByName("IPv6AddressMode", Disable);
    setDisable("IPv6IPAddress", Disable);
    setDisable("IPv6AddrMaskLenE8c", Disable);
    setDisable("IPv6GatewayE8c", Disable);
	setDisable("IPv6ReserveAddress", Disable);
    setDisable("IPv6StaticPrefix", Disable);
    setDisable("IPv6AddressStuff", Disable);
    if (GetCurrentWan().IPv4AddressMode.toString().toUpperCase() != "PPPOE")
	{
		setDisable("IPv4AddressMode3", 1);
	}
	else
	{
		setDisable("IPv4AddressMode1", 1);
		setDisable("IPv4AddressMode2", 1);
	}

	if (AddType == 2 && EditFlag.toUpperCase() == "ADD")
	{
	        var SessionVlanLimit  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULT_SESSION_VLAN_LIMIT);%>";
	        if (SessionVlanLimit == 1)
	        {
		    setDisable('VlanSwitch', 1);
	            setDisable('VlanId', 1);
		    setDisableByName('PriorityPolicy', 1);
                    setDisable('VlanPriority', 1);
		    setDisable('DefaultVlanPriority', 1);
		}

	}

	if (Wan.domain.length > 10 && Wan.Mode == "IP_Routed")
	{
		var i = 0;
		for (i = 0; i < GetWanList().length; i++)
		{
			if (GetWanList()[i].domain == Wan.domain)
			{
				break;
			}
		}
		var IPv6StaticPrefix = GetCurrentWan().IPv6PrefixMode.toString().toUpperCase();
        var IPv6StaticAdress = GetCurrentWan().IPv6AddressMode.toString().toUpperCase();
		if (GetWanList()[i].Mode.toUpperCase().indexOf("BRIDGE") >= 0 )
		{
			setDisableByName("IPv6PrefixMode", 0);

			if (IPv6StaticPrefix == "STATIC")
			{
				setDisable("IPv6StaticPrefix", 0);
			} 

			setDisableByName("IPv6AddressMode",0); 

			if (IPv6StaticAdress == "STATIC")
			{
				setDisable("IPv6IPAddress", 0);
				setDisable("IPv6AddrMaskLenE8c", 0);
                    setDisable("IPv6GatewayE8c", 0);
			}

			if (IPv6StaticAdress == "AUTOCONFIGURED")
			{
				setDisable("IPv6AddressStuff", 0);
			}		
		}
	}
	
}

function DisableUserMode(Disable)
{
    setDisable("WanSwitch", Disable);
    setDisableByName("EncapMode", Disable);
    setDisable("ProtocolType", Disable);
    setDisable("WanMode", Disable);
    setDisable("IPv4MXU", Disable);
    setDisable("ServiceList", Disable);
    setDisable("VlanSwitch", Disable);
    setDisable("VlanId", Disable);
    setDisable("VlanPriority", Disable);
    setDisableByName("PriorityPolicy",  Disable);
    setDisableByName("IPv4AddressMode", Disable);
    setDisable("IPv4MXU", Disable);
    setDisable("IPv4NatSwitch", Disable);
	if(false == IsSonetUser())
	{
    	setDisable("IPv4NatType", Disable);  
	}
    setDisable("LanDhcpSwitch", Disable);
    setDisable("IPv4VendorId", Disable);
    setDisable("IPv4ClientId", Disable);
    setDisable("IPv4IPAddress", Disable);
    setDisable("IPv4SubnetMask", Disable);
    setDisable("IPv4DefaultGateway", Disable);
    setDisable("IPv4PrimaryDNSServer", Disable);
    setDisable("IPv4SecondaryDNSServer", Disable);
    setDisable("LcpEchoReqCheck", Disable);
    setDisable("IPv4DialMode", Disable);
    setDisable("IPv4DialIdleTime", Disable);
    setDisable("IPv4IdleDisconnectMode", Disable);
    setDisable("IPv4WanMVlanId", Disable);
    setDisableByName("IPv4BindLanList", Disable);
    setDisableByName("IPv6PrefixMode", Disable);
    setDisableByName("IPv6DSLite", Disable);
    setDisable("IPv6AFTRName", Disable);
    setDisable("IPv6StaticPrefix", Disable);
    setDisableByName("IPv6AddressMode", Disable);
    setDisable("IPv6AddressStuff", Disable);
    setDisable("IPv6IPAddress", Disable);
    setDisable("IPv6AddrMaskLenE8c", Disable);
    setDisable("IPv6GatewayE8c", Disable);
    setDisable("IPv6ReserveAddress", Disable);
    setDisable("IPv6SubnetMask", Disable);
    setDisable("IPv6DefaultGateway", Disable);
    setDisable("IPv6PrimaryDNSServer", Disable);
    setDisable("IPv6SecondaryDNSServer", Disable);
    setDisable("IPv6WanMVlanId", Disable);
    setDisableByName("PriorityPolicy", Disable);
    setDisable("DefaultVlanPriority", Disable);
	setDisableByName("RDMode", Disable);
	setDisable("RdPrefix", Disable);
	setDisable("RdPrefixLen", Disable);
	setDisable("RdBRIPv4Address", Disable);
	setDisable("RdIPv4MaskLen", Disable);
	if (("1" == RadioWanFeature))	
	{
		setDisable("AccessType", Disable);
	}
}

function ControlUserMode()
{
    var Disable = IsAdminUser()==true ? 0 : 1;
	DisableUserMode(Disable);
}

function ControlPageByEditModeAndUser()
{
    var Wan = GetCurrentWan();
    if ('JSCMCC' == CfgModeWord.toUpperCase() && Wan.VlanId == 4031 && Wan.ServiceList == 'OTHER' && Wan.EncapMode == 'PPPoE' && IsWanHidden(domainTowanname(Wan.domain)) == true)
    {
		DisableUserMode(0);
    }
    if (IsAdminUser())
    {
		if ('JSCMCC' == CfgModeWord.toUpperCase() && Wan.VlanId == 4031 && Wan.ServiceList == 'OTHER' && Wan.EncapMode == 'PPPoE' && IsWanHidden(domainTowanname(Wan.domain)) == true)
		{
		     DisableUserMode(1);
			 setDisable("ButtonApply", 1);
		     setDisable("ButtonCancel", 1);
		}
	    else if ('TELECOM' == CfgModeWord.toUpperCase() && ((Wan.VlanId == 33) && (Wan.ServiceList == 'INTERNET') && (Wan.EncapMode == 'PPPoE')))
		{
		   DisableUserMode(1);
		}
	    else if ('TELECOM' == CfgModeWord.toUpperCase() && ((Wan.VlanId == 38) && (Wan.ServiceList == 'TR069_VOIP') && (Wan.EncapMode == 'IPoE')))
		{
		   DisableUserMode(1);
		}
		else
		{
            ControlEditMode();
		}
    }
    else
    {
        ControlUserMode();
    }
    
}

function E8CCheckDisable(Wan)
{
	setDisable('WanSwitch', 0);
	setDisable('VlanSwitch', 0);
	setDisable('VlanId', 0);
	setDisable('VlanPriority', 0);
	setDisableByName("PriorityPolicy", 0);
	setDisable('IPv4VendorId', 0);
	setDisable('IPv4ClientId', 0);
	setDisable('IPv4NatSwitch',0);
    setDisable('IPv4NatType',0);
	setDisable('IPv4WanMVlanId',0);
	
	if(!isReadModeForTR069Wan())
	{
		return;
	}
	
	setDisable("IPv4BindLanListCol", 0);
    if ((Wan.ServiceList.indexOf("TR069") >= 0) && (Wan.ServiceList.indexOf("INTERNET") < 0))
	{
		setDisable("IPv4BindLanListCol", 1);
	}
	
    if (EditFlag.toUpperCase() == "ADD")
	{
		return;
	}
	else
	{
		if(!IsOriginalTr069Type())
		{
			return;
		}
	}
	
	if ((Wan.ServiceList == "TR069") || (Wan.ServiceList == "TR069_VOIP"))
	{
		setDisable('WanSwitch', 1);
		setDisable('VlanSwitch', 1);
		setDisable('VlanId', 1);
		setDisable('VlanPriority', 1);
		setDisableByName("PriorityPolicy", 1);
		setDisable('IPv4VendorId', 1);
		setDisable('IPv4ClientId', 1);
		return;
	}
	
	if ((Wan.ServiceList == "TR069_INTERNET") || (Wan.ServiceList == "TR069_VOIP_INTERNET"))
	{
		setDisable('WanSwitch', 1);
		setDisable('VlanSwitch', 1);
		setDisable('VlanId', 1);
		setDisable('VlanPriority', 1);
		setDisableByName("PriorityPolicy", 1);
		setDisable('IPv4VendorId', 1);
		setDisable('IPv4ClientId', 1);
		setDisable('IPv4NatSwitch',1);
        setDisable('IPv4NatType',1);
		setDisable('IPv4WanMVlanId',1);
		return;
	}
}

function E8Ctr069CheckDisable(Wan)
{
	if(!isReadModeForTR069Wan())
	{
		return;
	}

    if (EditFlag.toUpperCase() == "ADD")
	{
		return;
	}
	else
	{
		if(!IsOriginalTr069Type())
		{
			return;
		}
	}

	if ((Wan.ServiceList == "TR069") || (Wan.ServiceList == "TR069_VOIP") || (Wan.ServiceList == "TR069_INTERNET") || (Wan.ServiceList == "TR069_VOIP_INTERNET"))
	{
		setDisable("WanMode", 1);
		setDisable("IPv4MXU", 1);
        setDisable("ProtocolType", 1);
        setDisable("ServiceList", 1);
        setDisableByName("IPv4AddressMode", 1);
		return;
	}
}

function ControlIPv6DSLite()
{    
	var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("IPv6DSLiteRow", 0);

	if((GetFeatureInfo().Dslite == "0") || (1 == GetCurrentWan().IPv4Enable))
    {
        return;
    }   
	if (WanMode != "IP_ROUTED")
    {
        return;
    }  
	setDisplay("IPv6DSLiteRow", 1); 
	if (true == IsCurrentRadioWan())
	{
		 setDisplay("IPv6DSLiteRow", 0);
	}
	
	setDisableByName("IPv6DSLite", 0);
	for(i = 0; i < GetWanList().length;i++)
	{
	    if( GetWanList()[i].IPv6DSLite.toString() != "Off" && GetWanList()[i].domain != GetCurrentWan().domain)
		{
		    setDisableByName("IPv6DSLite", 1);
		}
	}
}

function ControlIPv6AFTRName()
{   
	var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
	var WanIPv6DSLite = GetCurrentWan().IPv6DSLite.toString();
    
    setDisplay("IPv6AFTRNameRow", 0);
    if((GetFeatureInfo().Dslite == "0") || (1 == GetCurrentWan().IPv4Enable))     
    {
        return;
    }  
	if (WanMode != "IP_ROUTED")
    {
        return;
    }  
	setDisplay("IPv6AFTRNameRow", 1); 
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("IPv6AFTRNameRow", 0); 
	}

	setDisable("IPv6AFTRName", 0);
	if(WanIPv6DSLite != "Static")
	{
	    setDisable("IPv6AFTRName", 1);
		setText("IPv6AFTRName","");
	}
	
}


function ControlPriority()
{
    var PriorityPolicy = GetCurrentWan().PriorityPolicy.toString();
    setDisplay("DefaultVlanPriorityRow", 0);
    setDisplay("VlanPriorityRow", 0);
    setDisplay("PriorityPolicyRow", 0);
    if (GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("PriorityPolicyRow", 1);
    }
    if (PriorityPolicy.toUpperCase() == "SPECIFIED" && GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("VlanPriorityRow", 1);
    }  
    if (PriorityPolicy.toUpperCase() == "COPYFROMIPPRECEDENCE"  && GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("DefaultVlanPriorityRow", 1);
    } 
	
	if (true == IsCurrentRadioWan())
	{
		setDisplay("DefaultVlanPriorityRow", 0);
		setDisplay("VlanPriorityRow", 0);
		setDisplay("PriorityPolicyRow", 0);
	}
}

function ControlErrorWANCfg(Wan)
{
	if((Wan.IPv4Enable == 1) || (Wan.IPv6Enable == 1))
	{
		return ;
	}
	var Disable = 1;
	DisableUserMode(Disable);
	setDisable("UserName",Disable);
	setDisable("Password",Disable);
	setDisable("IPv6AFTRName",Disable);
	setDisable("ButtonApply",Disable);
	setDisable("ButtonCancel",Disable);
}

function ControlInfoRds()
{
	setDisplay("EncapModeRow", 0);
	setDisplay("ProtocolTypeRow", 0);
	setDisplay("WanModeRow", 0);
	setDisplay("ServiceListRow", 0);
	setDisplay("VlanSwitchRow", 0);
	setDisplay("VlanIdRow", 0);
	setDisplay("PriorityPolicyRow", 0);
	setDisplay("DefaultVlanPriorityRow", 0);
	setDisplay("VlanPriorityRow", 0);
	setDisplay("LcpEchoReqCheckRow", 0);
}

function ControlSonet()
{
	setDisplay("WanModeRow", 0);       
	setDisplay("VlanSwitchRow", 0);
	setDisplay("VlanIdRow", 0);
	setDisplay("PriorityPolicyRow", 0);
	setDisplay("DefaultVlanPriorityRow", 0);
	setDisplay("VlanPriorityRow", 0);
	setDisplay("IPv4BindLanListRow", 0);
	
	setDisplay("IPv4VendorIdRow", 0);       
	setDisplay("IPv4ClientIdRow", 0);
	setDisplay("IPv4WanMVlanIdRow", 0);
	
	setDisplay("IPv6WanMVlanIdRow", 0);
}

function ControlAntel()
{        
    if(IsAdminUser())
    {
        return;
    }

    if (CfgModeWord.toUpperCase() == 'ANTEL'
        && GetCurrentWan().EncapMode.toString().toUpperCase() == "PPPOE" 
        && GetCurrentWan().Mode == "IP_Routed")
    {
        setDisplay("WanIPv4InfoBarPanel", 0);
        setDisplay("WanIPv6InfoBarPanel", 0);
        
        $("#BasicInfoBarPanel>tr:gt(0)").hide();
        $("#UserNameRow").show();
        $("#PasswordRow").show();
    }
}

/* ̄Ԩ֧х֨׆ìҪȳWANࠚһŜɾԽۍўل */
function ControlScctDisable(Wan)
{
	var Mngtscct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>';
	if(Mngtscct == 1)
	{
		setDisable('ButtonApply', 1);
		setDisable('ButtonCancel', 1);
		setDisable('Newbutton', 1);
		setDisable('DeleteButton', 1);
	}
}

function ControlPage(Wan)
{  
    SetCurrentWan(Wan);

    ControlPageByEditModeAndUser();

    ControlPanel();
    ControlUserName();
    ControlApplyButton();
    ControlLcpCheck();
    ControlVlanId();
    ControlPriority();
    E8CCheckDisable(Wan);
    ControlIPv4DHCPEnable();
	Controlsvrlist();  
    ControlDstIPForwardingListVisibility();

    ControlIPv4AddressType();
    ControlIPv4EnableNAT();  
	ControlIPv4MXU();
    ControlIPv4VendorId();
    ControlIPv4ClientId();
    ControlIPv4StaticIPAddress();
    ControlIPv4Dial();
    ControlMVlan('IPv4');
    ControlIPv4LanWanBind();
    Control6RDParametersDisplay(Wan);

    ControlIPv6PrefixAcquireMode();
    ControlIPv6Prefix();
    ControlIPv6AddressAcquireMode();
	ControlIPv6ReservedPrefixAddress();
    ControlIPv6StaticIPAddress();
    ControlIPv6IPAddressStuff();

	ControlIPv6DSLite();
	ControlIPv6AFTRName();
	ControlMVlan('IPv6');

    ControlSpec();

    ControlPageByEditModeAndUser();
	if((GetCfgMode().BJCU == "1") && (Wan.ServiceList.match('INTERNET')))
    {
    	setDisable("WanMode", 0);
    }

    if (GetCfgMode().BJUNICOM == "1")
    {
        if ((Wan.ServiceList.toString().toUpperCase() =='INTERNET') || (Wan.ServiceList.toString().toUpperCase() =='OTHER'))
        {
            setDisable("IPv4DialMode", 0);
            setDisable("IPv4DialIdleTime", 0);
            setDisable("UserName",0);
    	    setDisable("Password",0);
	    }
	    else 
	    {
            setDisable("UserName",1);
    	    setDisable("Password",1);
        	setDisable("ButtonApply",1);
        	setDisable("ButtonCancel",1);
	    }
    }
    
    if (GetFeatureInfo().IPv6 == "0")
    {      
        setDisable("ProtocolType", 1);
        setSelect("ProtocolType", "IPv4");
    }

	E8Ctr069CheckDisable(Wan);
	ControlErrorWANCfg(Wan);
	if(IsSonetUser())
	{
		ControlSonet();
	}

	/* ࠘׆̄Ԩ֧хҳĦДʾ */
	ControlScctDisable(Wan);

	if(true == IsRDSGatewayUser())
	{
		ControlInfoRds();
	}
	CntrolAccessType();
	ControlRadioWan();
	ControlAntel();
	if (DisliteFeature == "1")
	{
	    ControlDislite();
	}

    return;
}

function OnChangeUI(ControlObject)
{
    var wanmodeobj = getElementById('WanMode');
    ChangeUISource = ControlObject;
    if(ControlObject == wanmodeobj)
    {
        Controlsvrlist();
    }
    ControlPage(GetPageData());
	if (1 == CfgGuide)
	{
		window.parent.adjustParentHeight();
	}
    
}

function GetAddType()
{
    return AddType;
}

function GetAddWanUrl(Wan)
{
	var wanConInst = 0;
	if (AddType != 2)
	{
		if(Wan.EncapMode.toString().toUpperCase() == 'PPPOE')
		{
			return 'GROUP_a_x=InternetGatewayDevice.WANDevice.1.WANConnectionDevice&GROUP_a_y=GROUP_a_x.WANPPPConnection';
		}
		else
		{
			return 'GROUP_a_x=InternetGatewayDevice.WANDevice.1.WANConnectionDevice&GROUP_a_y=GROUP_a_x.WANIPConnection';
		}
	}
	else
	{
		wanConInst = GetWanInfoSelected().domain.split(".")[4];
	
		if(Wan.EncapMode.toString().toUpperCase() == 'PPPOE')
		{
			return 'GROUP_a_y=InternetGatewayDevice.WANDevice.1.WANConnectionDevice.' + wanConInst + '.WANPPPConnection';
		}
		else
		{
			return 'GROUP_a_y=InternetGatewayDevice.WANDevice.1.WANConnectionDevice.' + wanConInst + '.WANIPConnection';
		}
	}
}

function GetEditWanUrl(Wan)
{
    return Wan.domain;
}

function IsLanBind(Name, IPv4BindLanList)
{
    for (var i = 0; i < IPv4BindLanList.length; i++)
    {
        if (IPv4BindLanList[i] != undefined && IPv4BindLanList[i] != null)
        if (Name.toString().toUpperCase() == IPv4BindLanList[i].toString().toUpperCase())
        {
            return true;
        }
    }
    return false;
}

function ConvertMac(WanMac)
{
	var NewWanMac = WanMac.replace(/\:/g,"-");
	return NewWanMac;
}

function IsOldServerListType(type)
{
	switch(type)
	{
		case 'TR069':
		case 'INTERNET':
		case 'TR069_INTERNET':
		case 'VOIP':
		case 'TR069_VOIP':
		case 'VOIP_INTERNET':
		case 'TR069_VOIP_INTERNET':
		case 'IPTV':
		case 'OTHER':
			return true;
	}
	
	return false;
}


function GetWanInfoSelected()
{
    var rml = document.getElementsByName("wanInstTablerml");
	if (rml == null)
	{
	    return null;
	}	
    if (rml.length > 0)
    {
	    for (var i = 0; i < rml.length; i++)
	    {
	        if (rml[i].checked == true)
            {   
                break;       
            }
        }
		
		for (var tmp = 0;tmp < WanList.length; tmp++)
	    {
	        if (WanList[tmp].domain == rml[i].value)
		    {
		        return WanList[tmp];
		    }
	    }
		
		return null;
    }

	else if (rml.checked == true)
    {
        for (var tmp = 0;tmp < WanList.length; tmp++)
	    {
	        if (WanList[tmp].domain == rml.value)
		    {
		        return WanList[tmp];
		    }
	    }
		
		return null;
    }
}	

function GetSelectedWanNum()
{
    var rml = getElement('wanInstTablerml');
    var numChoosed = 0;
	if (rml == null)
	{
	    return numChoosed;
	}
    if (rml.length > 0)
    {
	    for (var i = 0; i < rml.length; i++)
	    {
	        if (rml[i].checked == true)
            {   
                numChoosed = numChoosed + 1;
            }
        }
    }
    else if (rml.checked == true)
    {
        numChoosed = numChoosed + 1;
    }
	
	return numChoosed;
}	
function btnAddWanCnt()
{
	if (GetSelectedWanNum() > 1)
	{
	    AlertMsg("selectonewan");
		return false;
	}
	

	CurrentWan = defaultWan.clone();

	var wanInfoTmp = null;
    if (AddType == 2)
	{
	    wanInfoTmp = GetWanInfoSelected();
		if (wanInfoTmp == null)
		{
		    return null;
		}
		if (true == IsRadioWanSupported(wanInfoTmp))
		{
			AlertMsg("RadioWanNoSession");
			return false;
		}
		return true;
	}
    return null;
}	

function GetBrotherWan(wanTmp)
{
    var i = 0;
	for (i = 0; i < GetWanList().length; i++)
	{
		if ((GetWanList()[i].domain.substring(0, 55) == 
	       wanTmp.domain.substring(0, 55))
           && (GetWanList()[i].domain != wanTmp.domain))
        {
			return GetWanList()[i];
		}				
	}
	return null;
}

function GetBrotherWanindex(wanTmp)
{
    var i = 0;
	for (i = 0; i < GetWanList().length; i++)
	{
		if ((GetWanList()[i].domain.substring(0, 55) == 
	       wanTmp.domain.substring(0, 55))
           && (GetWanList()[i].domain != wanTmp.domain))
        {
			return i;
		}				
	}
	return null;
}


function IsAnyWanSelected()
{
    var rml = getElement('wanInstTablerml');
    var ChooseFlag = false;
	if (rml == null)
	{
	    return ChooseFlag;
	}
    if ( rml.length > 0)
    {
	    for (var i = 0; i < rml.length; i++)
	    {
	        if (rml[i].checked == true)
            {   
                ChooseFlag = true;
            }
        }
    }
    else if (rml.checked == true)
    {
        ChooseFlag = true;
    }
	return ChooseFlag;
}

function wanInstTableselectRemoveCnt(curCheck)
{
    if (IsAnyWanSelected() == true)
	{
	    setText('Newbutton', Languages['New_Connection']);
		AddType = 2;
	}
	else
	{
	    setText('Newbutton', Languages['Connection']);
		AddType = 1;
	}
}