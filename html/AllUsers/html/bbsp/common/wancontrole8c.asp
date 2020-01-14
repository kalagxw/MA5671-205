var CurrentWan = null;
var EditFlag = "";
var ChangeUISource = "";
var AddType     = 1;
var CurrentWan = new WanInfoInst();
var defaultWan  = new WanInfoInst(); 
var COMPLEX_CGI_PREFIX='Add_';
var IsE8C = isE8cAndCMCC();
var MngtShct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SHCT);%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
      
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
		setDisplay("WanPrefix_checkboxRow", 0);
        setDisplay("WanPrefix_selectRow", 0);
        setDisplay("WanIPv6Address_Pre_textRow", 0);
		setDisplay("WanIPv6Address_selectRow", 0);
		
        setDisplay("IPv6AddressStuffRow", 0);   
        setDisplay("WanIPv6Address_textRow", 0);
        setDisplay("IPv6AddrMaskLenE8cRow", 0);
        setDisplay("WanIPv6_Gateway_textRow", 0);
		setDisplay("IPv6ReserveAddress", 0);
        setDisplay("IPv6SubnetMaskRow", 0);
        setDisplay("IPv6DefaultGatewayRow", 0);
        setDisplay("WanIPv6Pri_DNS_textRow", 0);
        setDisplay("WanIPv6Sec_DNS_textRow", 0);  
        setDisplay("IPv6WanMVlanIdRow", 0);     
        setDisable("WanIP_Mode_select", 1);
        setSelect("WanIP_Mode_select", "IPv4");

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
    
}


function ControlIPv4AddressMode()
{
    setDisplay("WanIPv4Address_selectRow", 1);
    if (GetCurrentWan().Mode.toString().toUpperCase() != "IP_ROUTED")
    {
        setDisplay("WanIPv4Address_selectRow", 0);
    }

}

function ControlIPv4DHCPEnable()
{
    var ServiceList = GetCurrentWan().ServiceList.toString().toUpperCase();
    var src = getElementById('WanServiceList_select');
    
    setDisplay("LanDhcpSwitchRow", 0);
    if ( ServiceList.match('INTERNET') || ServiceList.match('IPTV') || ServiceList.match('OTHER') )
    {
        if(isE8cAndCMCC())
        {
	        setDisplay("LanDhcpSwitchRow", 1);
	    }		
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
	
	setDisplay("DstIPForwardingListRow", 0);
	setDisplay("DstIPForwardingList", 0);
	setDisplay("DstIPForwardingListRow", 1);
	setDisplay("DstIPForwardingList", 1);
	
	if ( false == IsDstIPForwardingListVisibility(Wan,ServiceList) )
	{
		setDisplay("DstIPForwardingListRow", 0);
		setDisplay("DstIPForwardingList", 0);
	}
}

function RemoveAllFromSelectByKey(objSelect, objItemKey) 
{             
	for (var i = objSelect.options.length -1 ; i >= 0; i--) 
	{  
		if(objSelect.options[i].value.indexOf(objItemKey) >= 0 )  
		{ 
            objSelect.options[i]=null;            
        }     
    }
}

function RemoveItemFromSelect(objSelect, objItemValue) 
{             
    for (var i = 0; i < objSelect.options.length; i++) 
	{  
	
		if(objSelect.options[i].value == objItemValue) 
		{        
            objSelect.options[i]=null;         
            break;        
        }     
    }
}

function displayWanMode()
{
	var wanMode = getElementById('WanConnectMode_select');
	if(bin5board() == true) 
	{
		RemoveItemFromSelect(wanMode, 'IP_Bridged');
	}
}

function displayProtocolType()
{
	var protoType = getElementById('WanIP_Mode_select');
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

function bin4board_nonvoice()
{
	var IsSupportVoice = '<%HW_WEB_GetFeatureSupport(HW_VSPA_FEATURE_VOIP);%>';
	if(productName == 'HG8045A' || productName == 'HG8045H' || productName == 'HG8045D' || IsSupportVoice != '1')
	{
		return true;
	}
	return false;
}


function Controlsvrlist()
{
	var svrlist = getElementById('WanServiceList_select');
	var Wan = GetCurrentWan();
	
	svrlist.options.length = 0;

	svrlist.options.add(new Option(Languages['TR069e8c'],Languages['TR069']));
	svrlist.options.add(new Option(Languages['INTERNETe8c'],Languages['INTERNET']));
	svrlist.options.add(new Option(Languages['VOIPe8c'],Languages['VOIP']));
	svrlist.options.add(new Option(Languages['OTHERe8c'],Languages['OTHER']));
	svrlist.options.add(new Option(Languages['VOIP_INTERNETe8c'],Languages['VOIP_INTERNET']));
	svrlist.options.add(new Option(Languages['TR069_INTERNETe8c'],Languages['TR069_INTERNET']));
	svrlist.options.add(new Option(Languages['TR069_VOIPe8c'],Languages['TR069_VOIP']));
	svrlist.options.add(new Option(Languages['TR069_VOIP_INTERNETe8c'],Languages['TR069_VOIP_INTERNET']));
	
	svrlist.value = Languages['INTERNET'] ;
	
	if(getValue('WanConnectMode_select').toString().toUpperCase().indexOf("BRIDGED") >= 0)
	{
		svrlist.options.length = 0;
		svrlist.options.add(new Option(Languages['INTERNETe8c'],Languages['INTERNET']));
		svrlist.options.add(new Option(Languages['OTHERe8c'],Languages['OTHER']));
		
		switch(GetCurrentWan().ServiceList.toString().toUpperCase()) 
		{
			case Languages['INTERNET']:
			case Languages['OTHER']:
				svrlist.value = GetCurrentWan().ServiceList.toString().toUpperCase();
				break;
			default:
				var servalue = GetCurrentWan().ServiceList.toString().toUpperCase();
				if(servalue == Languages['TR069'])
				{
					svrlist.options.add(new Option(Languages['TR069e8c'],"TR069"));
					setSelect("WanServiceList_select","TR069");
				}
				if(servalue == Languages['TR069_INTERNET'])
				{
					svrlist.options.add(new Option(Languages['TR069_INTERNETe8c'],"TR069_INTERNET"));
					setSelect("WanServiceList_select","TR069_INTERNET");
				}
				if(servalue == Languages['TR069_VOIP'])
				{
					svrlist.options.add(new Option(Languages['TR069_VOIPe8c'],"TR069_VOIP"));
					setSelect("WanServiceList_select","TR069_VOIP");
				}
				if(servalue == Languages['VOIP'])
				{
					svrlist.options.add(new Option(Languages['VOIPe8c'],"VOIP"));
					setSelect("WanServiceList_select","VOIP");
				}
				if(servalue == Languages['VOIP_INTERNET'])
				{
					svrlist.options.add(new Option(Languages['VOIP_INTERNETe8c'],"VOIP_INTERNET"));
					setSelect("WanServiceList_select","VOIP_INTERNET");
				}
				if(servalue == Languages['TR069_VOIP_INTERNET'])
				{
					svrlist.options.add(new Option(Languages['TR069_VOIP_INTERNETe8c'],"TR069_VOIP_INTERNET"));
					setSelect("WanServiceList_select","TR069_VOIP_INTERNET");
				}
				break;
		}
		
		return ;
	}
	
	if ((bin4board_nonvoice() == true)&&(selctIndex == -1))
	{
		RemoveAllFromSelectByKey(svrlist , Languages['VOIP']);
	}

	if(bin5board() == true && EditFlag.toUpperCase() == "ADD") 
	{
		RemoveItemFromSelect(svrlist , Languages['INTERNET']);
		RemoveItemFromSelect(svrlist , Languages['TR069_INTERNET']);
		RemoveItemFromSelect(svrlist , Languages['VOIP_INTERNET']);
		RemoveItemFromSelect(svrlist , Languages['TR069_VOIP_INTERNET']);
		RemoveItemFromSelect(svrlist , Languages['OTHER']);
		
		if(Wan.ServiceList.toString().toUpperCase()=='INTERNET')
		{
		    svrlist.value=Languages['TR069'];
		}
		else
		{
		    svrlist.value=Languages[Wan.ServiceList.toString().toUpperCase()];
		}
		
		CleanServiceListVoip();
		return;
	}
	
	svrlist.value = Wan.ServiceList.toString().toUpperCase();
	CleanServiceListVoip();
	return;

}

function ControlIPv4MXU()
{
    var WanProtocolType = GetCurrentWan().ProtocolType.toString();
    var WanIPv6DSLite = GetCurrentWan().IPv6DSLite.toString();
    
    document.getElementById("WanMTU_textRow").cells[0].innerHTML = Languages['IPv4MXUe8c'];
	
    setDisplay("WanMTU_textRow", 1);
	
	if ((GetCurrentWan().Mode.toString().toUpperCase() != "IP_ROUTED") 
		|| (GetCfgMode().PCCWHK == "1"))
	{
		setDisplay("WanMTU_textRow", 0);
	}
    
    if (WanProtocolType.match("IPv6"))
    {
        document.getElementById("WanMTU_textRemark").innerHTML = "(1280-1540)";
		getElById('WanMTU_text').title = "(1280-1540)";
    }
    else
    {
        document.getElementById("WanMTU_textRemark").innerHTML = "(1-1540)";
		getElById('WanMTU_text').title = "(1-1540)";
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
    
    if (GetCurrentWan().Mode.toString().toUpperCase().indexOf("BRIDGED") >= 0)
    {
       setCheck('IPv4NatSwitch', 1);
       return; 
    }
    
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
        
        if (GetCurrentWan().IPv4NATEnable.toString().toUpperCase() == "1")
    	{
 			setDisable("IPv4NatType", 0);   
    	}
    	else
    	{
    		setDisable("IPv4NatType", 1);
    	}
        
    }
}


function ControlVlanId()
{
	var VlanId;
    setDisplay("WanVlanID_textRow", 0);
    if (GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("WanVlanID_textRow", 1);
		VlanId = GetCurrentWan().VlanId;
		if (0 == VlanId)
		{
			if (GetCurrentBin().toUpperCase() == "E8C")
			{
				setText('WanVlanID_text',1);
			}
			else
        	{
				setText('WanVlanID_text','');
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
}


function ControlIPv4ClientId()
{
    setDisplay("IPv4ClientIdRow", 0);
    if ( (!isE8cAndCMCC()) && GetCurrentWan().Mode.toString().toUpperCase() == "IP_ROUTED" && GetCurrentWan().IPv4AddressMode.toString().toUpperCase() == "DHCP")
    {
        setDisplay("IPv4ClientIdRow", 1);
    }
}


function ControlIPv4StaticIPAddress()
{
    var IPv4AddressType = GetCurrentWan().IPv4AddressMode.toString().toUpperCase();
    setDisplay("WanIPv4Address_textRow", 0);
    setDisplay("WanSubmask_textRow", 0);
    setDisplay("WanGateway_textRow", 0);
    setDisplay("WanPri_DNS_textRow", 0);
    setDisplay("WanSec_DNS_textRow", 0);
    if (IPv4AddressType == "STATIC" && GetCurrentWan().Mode.toString().toUpperCase() == "IP_ROUTED")
    {
		setDisplay("WanIPv4Address_textRow", 1);
		setDisplay("WanSubmask_textRow", 1);
		setDisplay("WanGateway_textRow", 1);
		setDisplay("WanPri_DNS_textRow", 1);
		setDisplay("WanSec_DNS_textRow", 1);
    }

}


function ControlUserName()
{
    var EncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();
    setDisplay("WanUserName_textRow", 0);
    setDisplay("WanPassword_textRow", 0);
    if (EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed")
    {
        setDisplay("WanUserName_textRow", 1);
        setDisplay("WanPassword_textRow", 1);
    }    
}

function ControlApplyButton()
{
	var DisableButton = false; 

	if (!IsAdminUser())
	{
		var EncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();

		if(EncapMode == "PPPOE" && GetCurrentWan().Mode == "IP_Routed")
		{
			DisableButton = false;	
		}
		else
		{
			DisableButton = true;
		}

		if( GetCurrentWan().ServiceList.toString().toUpperCase() =='INTERNET'
				&&  GetCfgMode().BJCU == "1" )
		{
			DisableButton = false;
		}        
	}
	
	if (("ADD" == EditFlag.toUpperCase()) && (GetWanList().length >= 8))
	{
		DisableButton = true;
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
}


function ControlIPv4Dial()
{
    setDisplay("IPv4DialModeRow", 0);
    setDisplay("IPv4DialIdleTimeRow", 0);
    setDisplay("IPv4IdleDisconnectModeRow", 0);     
    
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
    

    if (GetCurrentWan().ServiceList.toString().toUpperCase() != "INTERNET")
    {
        return;
    }
    
    setDisplay("IPv4DialModeRow", 1);
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
	var IPv4AddressTypeList = getElementById('WanIPv4Address_select');
    
    setDisplay("WanIPv4Address_selectRow", 1);
    if (Wan.Mode.toString().toUpperCase() != "IP_ROUTED")
    {
        setDisplay("WanIPv4Address_selectRow", 0);
        return;
    } 
	
	IPv4AddressTypeList.options.length = 0;
	IPv4AddressTypeList.options.add(new Option(Languages['DHCP'],"DHCP"));
	IPv4AddressTypeList.options.add(new Option(Languages['Static'],"Static"));
	IPv4AddressTypeList.options.add(new Option(Languages['PPPoE'],"PPPoE"));

    if (Wan.EncapMode.toString().toUpperCase() == "IPOE")
    {
		RemoveItemFromSelect(IPv4AddressTypeList , "PPPoE");
		if(Wan.IPv4AddressMode.toString().toUpperCase() == "DHCP")
		{
			setSelect("WanIPv4Address_select","DHCP");
		}
		else if(Wan.IPv4AddressMode.toString().toUpperCase() == "STATIC")
		{
			setSelect("WanIPv4Address_select","Static");
		}
		else
		{
			setSelect("WanIPv4Address_select","DHCP");
			Wan.IPv4AddressMode = "DHCP";
		}
		
		if((BirdgetoRoute() == true) && (Wan.IPv4AddressMode.toString().toUpperCase() == "STATIC"))
		{
			if(getElById("WanIPv4Address_text").value == '0.0.0.0')
			{
				setText('WanIPv4Address_text','');
			}
			if(getElById("WanSubmask_text").value == '0.0.0.0')
			{
				setText('WanSubmask_text','');
			}
			if(getElById("WanGateway_text").value == '0.0.0.0')
			{
				setText('WanGateway_text','');
			}
		}
		  
    }

    else if (Wan.EncapMode.toString().toUpperCase() == "PPPOE")
    {
		RemoveItemFromSelect(IPv4AddressTypeList , "DHCP");
		RemoveItemFromSelect(IPv4AddressTypeList , "Static");
		setSelect("WanIPv4Address_select","PPPOE");
        Wan.IPv4AddressMode = "PPPoE";
    }
}

function ControlIPv4LanWanBind()
{
    var Wan = GetCurrentWan();
    var ISPPortList = GetISPPortList();
    
    if (FeatureInfo.LanSsidWanBind == "0")
    {
        setDisplay('Wan_Port_checkboxRow',0);
		setDisplay('Wan_SSID_checkboxRow',0);
        return;
    }
    
    for (var i = 1; i <= parseInt(TopoInfo.EthNum); i++)
    {
        if (IsL3Mode(i) == "0")
        {
            setDisable("Wan_Port_checkbox"+i, 1);
        }
    }
    
    for (var i = parseInt(TopoInfo.EthNum)+1; i <= 4; i++)
    {
        setDisplay("DivWan_Port_checkbox"+i, 0);
    }

	var DoubleFreqFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>';      

	if (1 != DoubleFreqFlag)
	{	
		for (var i = parseInt(TopoInfo.SSIDNum) + 1; i <= 8; i++)
		{
			setDisplay("DivWan_SSID_checkbox"+i, 0);
		}
	}

	
    if(ISPPortList.length > 0)
    {
        for (var i = 1; i <= parseInt(TopoInfo.SSIDNum); i++)
        {
            var pos = ArrayIndexOf(ISPPortList, 'SSID'+i);
			if(pos >= 0)
            {
                var DivID = i;
                setDisplay("DivWan_SSID_checkbox"+DivID, 0);
            }
        }
    }
    

	if(1 == DoubleFreqFlag)
	{
		for (var i = 0; i < WlanList.length; i++)
		{
			var tid = parseInt(i+5);
			var tidssid = tid -4;
			if (WlanList[i].bindenable == "0")
			{  
				setDisable("Wan_SSID_checkbox"+tidssid, 1);
			}

			if((WlanList[i].bindenable == "1")&&(enbl5G != 1))
			{			
				if(tid > 4)
				{
					setDisable("Wan_SSID_checkbox"+tidssid, 1);
				}
			}
			
			if((WlanList[i].bindenable == "1")&&(enbl2G != 1))
			{
				if(tid < 5)
				{
					setDisable("Wan_SSID_checkbox"+tidssid, 1);
				}
			}
		}
	}
	else
	{
		for (var i = 0; i < WlanList.length; i++)
		{
			var tidssid = parseInt(i+1);
			if (WlanList[i].bindenable == "0")
			{  
				setDisable("Wan_SSID_checkbox"+tidssid, 1);
			}
		}
	}
    
    setDisplay('Wan_Port_checkboxRow',0);
	setDisplay('Wan_SSID_checkboxRow',0);
    if (Wan.ServiceList.match("INTERNET")
     || Wan.ServiceList.match("OTHER")
	 || Wan.ServiceList.match("IPTV"))
	 {
	    setDisplay('Wan_Port_checkboxRow',1);
		setDisplay('Wan_SSID_checkboxRow',1);
	 }
	 var WlanAvailableFlag= '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';
	 if('1' != WlanAvailableFlag)
	 {
	 	setDisplay('Wan_SSID_checkboxRow',0);
	 }
           
}


function ControlIPv6PrefixAcquireMode()
{
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    var Wan = GetCurrentWan();
    setDisplay("WanPrefix_checkboxRow", 0);
	setDisplay("WanPrefix_selectRow", 0);
	
    if (WanMode == "IP_ROUTED" && Wan.ServiceList.toUpperCase() != "VOIP")
    {
        setDisplay("WanPrefix_checkboxRow", 1);
		if(getCheckVal("WanPrefix_checkbox") == '1')
		{
			setDisplay("WanPrefix_selectRow", 1);
		}
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
}

function ControlIPv6Prefix()
{
    var IPv6StaticPrefix = GetCurrentWan().IPv6PrefixMode.toString().toUpperCase();
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("WanIPv6Address_Pre_textRow", 0);
    if (IPv6StaticPrefix == "STATIC" && WanMode == "IP_ROUTED")
    {
        setDisplay("WanIPv6Address_Pre_textRow", 1);
    }    
}


function ControlIPv6AddressAcquireMode()
{
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    var WanEncapMode = GetCurrentWan().EncapMode.toString().toUpperCase();
	var IPv6AddressList = getElementById('WanIPv6Address_select');
	var Wan = GetCurrentWan();
	setDisplay("WanIPv6Address_selectRow", 0);
	
    if (WanMode == "IP_ROUTED")
    {
		setDisplay("WanIPv6Address_selectRow", 1);
    }
	
	if(WanEncapMode == "PPPOE")
	{
		IPv6AddressList.options.length = 0;
		IPv6AddressList.options.add(new Option(Languages['Autoe8c'],"AutoConfigured"));
		IPv6AddressList.options.add(new Option(Languages['DHCPV6e8c'],"DHCPv6"));
		IPv6AddressList.options.add(new Option(Languages['None'],"None"));
		
		if ((Wan.IPv6AddressMode.toString().toUpperCase() != "AUTOCONFIGURED")
		&& (Wan.IPv6AddressMode.toString().toUpperCase() != "DHCPV6")
        && (Wan.IPv6AddressMode.toString().toUpperCase() != "NONE"))
        {
            setSelect("WanIPv6Address_select","AutoConfigured");
            Wan.IPv6AddressMode = "AutoConfigured"; 
        } 
	}
	else
	{
		IPv6AddressList.options.length = 0;
		IPv6AddressList.options.add(new Option(Languages['Autoe8c'],"AutoConfigured"));
		IPv6AddressList.options.add(new Option(Languages['DHCPV6e8c'],"DHCPv6"));
		IPv6AddressList.options.add(new Option(Languages['Statice8c'],"Static"));
		IPv6AddressList.options.add(new Option(Languages['None'],"None"));
	}
	IPv6AddressList.value = GetCurrentWan().IPv6AddressMode;
	return;
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
}

function ControlIPv6StaticIPAddress()
{
    var IPv6AddressType = GetCurrentWan().IPv6AddressMode.toString().toUpperCase();
    var WanMode = GetCurrentWan().Mode.toString().toUpperCase();

    setDisplay("WanIPv6Address_textRow", 0);
    setDisplay("IPv6AddrMaskLenE8cRow", 0);
    setDisplay("WanIPv6_Gateway_textRow", 0);
    setDisplay("IPv6SubnetMaskRow", 0);
    setDisplay("IPv6DefaultGatewayRow", 0);
    setDisplay("WanIPv6Pri_DNS_textRow", 0);
    setDisplay("WanIPv6Sec_DNS_textRow", 0);

    if (IPv6AddressType == "STATIC" && WanMode == "IP_ROUTED")
    {
        setDisplay("WanIPv6Address_textRow", 1);
        setDisplay("IPv6AddrMaskLenE8cRow", 1);
        setDisplay("WanIPv6_Gateway_textRow", 1);
        setDisplay("IPv6SubnetMaskRow", 1);
        setDisplay("IPv6DefaultGatewayRow", 1);
        setDisplay("WanIPv6Pri_DNS_textRow", 1);
        setDisplay("WanIPv6Sec_DNS_textRow", 1);
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

	setDisplay("IPv6AddressStuffRow", 1);

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

    setDisable("WanAddress_select", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
	
    setDisable("WanIP_Mode_select", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
    setDisable("WanConnectMode_select", 0);
    if((Disable) && (bin3board() == true))
    {
        setDisable("WanConnectMode_select", 1);
    }
    setDisable("WanMTU_text", 0);
    setDisable("WanServiceList_select", EditFlag.toUpperCase() == "ADD" ? 0 : 1);
    setDisable("WanIPv4Address_select", Disable);
	setDisable("WanPrefix_checkbox", Disable);
    setDisable("WanPrefix_select", Disable);
    setDisableByName("IPv6AddressMode", Disable);
	
	setDisable("WanIPv6Address_select", Disable);
    setDisable("WanIPv6Address_text", Disable);
    setDisable("IPv6AddrMaskLenE8c", Disable);
    setDisable("WanIPv6_Gateway_text", Disable);
	setDisable("IPv6ReserveAddress", Disable);
    setDisable("WanIPv6Address_Pre_text", Disable);
    setDisable("IPv6AddressStuff", Disable);

	if (AddType == 2 && EditFlag.toUpperCase() == "ADD")
	{
	        var SessionVlanLimit  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULT_SESSION_VLAN_LIMIT);%>";
	        if (SessionVlanLimit == 1)
	        {
		    setDisable('WanVlan_Enable', 1);
	            setDisable('WanVlanID_text', 1);
		    setDisableByName('PriorityPolicy', 1);
                    setDisable('Wan_802_1_P_select', 1);
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
			setDisable("WanPrefix_checkbox", 0);
			setDisable("WanPrefix_select", 0);

			if (IPv6StaticPrefix == "STATIC")
			{
				setDisable("WanIPv6Address_Pre_text", 0);
			} 

			setDisableByName("IPv6AddressMode",0); 
			setDisable("WanIPv6Address_select",0);

			if (IPv6StaticAdress == "STATIC")
			{
				setDisable("WanIPv6Address_text", 0);
				setDisable("IPv6AddrMaskLenE8c", 0);
                    setDisable("WanIPv6_Gateway_text", 0);
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
    setDisable("WanAddress_select", Disable);
    setDisable("WanIP_Mode_select", Disable);
    setDisable("WanConnectMode_select", Disable);
    setDisable("WanMTU_text", Disable);
    setDisable("WanServiceList_select", Disable);
    setDisable("WanVlan_Enable", Disable);
    setDisable("WanVlanID_text", Disable);
    setDisable("Wan_802_1_P_select", Disable);
    setDisableByName("PriorityPolicy",  Disable);
    setDisable("WanIPv4Address_select", Disable);
    setDisable("WanMTU_text", Disable);
    setDisable("IPv4NatSwitch", Disable);
    setDisable("IPv4NatType", Disable);  
    setDisable("IPv4VendorId", Disable);
    setDisable("IPv4ClientId", Disable);
    setDisable("WanIPv4Address_text", Disable);
    setDisable("WanSubmask_text", Disable);
    setDisable("WanGateway_text", Disable);
    setDisable("WanPri_DNS_text", Disable);
    setDisable("WanSec_DNS_text", Disable);
    setDisable("LcpEchoReqCheck", Disable);
    setDisable("IPv4DialMode", Disable);
    setDisable("IPv4DialIdleTime", Disable);
    setDisable("IPv4IdleDisconnectMode", Disable);
    setDisable("IPv4WanMVlanId", Disable);
    setDisableByName("Wan_Port_checkbox", Disable);
	setDisableByName("Wan_SSID_checkbox", Disable);
	setDisable("WanPrefix_checkbox", Disable);
	setDisable("WanPrefix_checkbox", Disable);
    setDisable("WanPrefix_select", Disable);
	setDisable("WanDslite_checkbox", Disable);
    setDisableByName("IPv6DSLite", Disable);
    setDisable("IPv6AFTRName", Disable);
    setDisable("WanIPv6Address_Pre_text", Disable);
    setDisableByName("IPv6AddressMode", Disable);
	setDisable("WanIPv6Address_select", Disable);
	
    setDisable("IPv6AddressStuff", Disable);
    setDisable("WanIPv6Address_text", Disable);
    setDisable("IPv6AddrMaskLenE8c", Disable);
    setDisable("WanIPv6_Gateway_text", Disable);
    setDisable("IPv6ReserveAddress", Disable);
    setDisable("IPv6SubnetMask", Disable);
    setDisable("IPv6DefaultGateway", Disable);
    setDisable("WanIPv6Pri_DNS_text", Disable);
    setDisable("WanIPv6Sec_DNS_text", Disable);
    setDisable("IPv6WanMVlanId", Disable);
    setDisableByName("PriorityPolicy", Disable);
    setDisable("DefaultVlanPriority", Disable);
	setDisableByName("RDMode", Disable);
	setDisable("RdPrefix", Disable);
	setDisable("RdPrefixLen", Disable);
	setDisable("RdBRIPv4Address", Disable);
	setDisable("RdIPv4MaskLen", Disable);
}

function ControlUserMode()
{
    var Disable = IsAdminUser()==true ? 0 : 1;
	DisableUserMode(Disable);
}

function ControlPageByEditModeAndUser()
{
    if (IsAdminUser())
    {
        ControlEditMode();
    }
    else
    {
        ControlUserMode();
    }
    
}

function E8CCheckDisable(Wan)
{
	setDisable('WanSwitch', 0);
	setDisable('WanVlan_Enable', 0);
	setDisable('WanVlanID_text', 0);
	setDisable('Wan_802_1_P_select', 0);
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
	
	setDisable("Wan_Port_checkboxCol", 0);
	setDisable("Wan_SSID_checkboxCol", 0);
    if ((Wan.ServiceList.indexOf("TR069") >= 0) && (Wan.ServiceList.indexOf("INTERNET") < 0))
	{
		setDisable("Wan_Port_checkboxCol", 1);
		setDisable("Wan_SSID_checkboxCol", 1);
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
		setDisable('WanVlan_Enable', 1);
		setDisable('WanVlanID_text', 1);
		setDisable('Wan_802_1_P_select', 1);
		setDisableByName("PriorityPolicy", 1);
		setDisable('IPv4VendorId', 1);
		setDisable('IPv4ClientId', 1);
		return;
	}
	
	if ((Wan.ServiceList == "TR069_INTERNET") || (Wan.ServiceList == "TR069_VOIP_INTERNET"))
	{
		setDisable('WanSwitch', 1);
		setDisable('WanVlan_Enable', 1);
		setDisable('WanVlanID_text', 1);
		setDisable('Wan_802_1_P_select', 1);
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
	var Mngtscct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_SCCT);%>';
	if(Mngtscct == 1)
	{
		if((Wan.domain.indexOf("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.1") >= 0) || 
		   (Wan.domain.indexOf("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.2") >= 0) ||
		   (Wan.domain.indexOf("InternetGatewayDevice.WANDevice.1.WANConnectionDevice.3") >= 0))
		{
			setDisable("WanConnectMode_select", 1);
			setDisable("WanMTU_text", 1);
	        setDisable("WanIP_Mode_select", 1);
	        setDisable("WanServiceList_select", 1);
	        setDisable("WanIPv4Address_select", 1);
	        setDisable("WanSwitchCol", 1);
	        setDisable("WanVlan_EnableCol", 1);
	        setDisable("PriorityPolicyCol", 1);
	        setDisable("WanVlanID_text", 1);
			setDisable("Wan_802_1_P_select", 1);
			setDisable("Wan_Port_checkboxCol", 1);
			setDisable("IPv4NatSwitchCol", 1);
			setDisable("IPv4WanMVlanId", 1);
			setDisable("IPv4VendorId", 1);
			setDisable("LanDhcpSwitchCol", 1);
			setDisable("DstIPForwardingList", 1);	
			setDisable("Wan_SSID_checkboxCol", 1);		
			setDisable("ButtonDelete", 1);
	        setDisable("ButtonNew", 1);
		}
	}

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
		setDisable("WanConnectMode_select", 1);
		setDisable("WanMTU_text", 1);
        setDisable("WanIP_Mode_select", 1);
        setDisable("WanServiceList_select", 1);
        setDisable("WanIPv4Address_select", 1);
		return;
	}
}

function ControlIPv6DSLite()
{    
	var WanMode = GetCurrentWan().Mode.toString().toUpperCase();
    
    setDisplay("IPv6DSLiteRow", 0);
	setDisplay("WanDslite_checkboxRow", 0);

	if((GetFeatureInfo().Dslite == "0") || (1 == GetCurrentWan().IPv4Enable))
    {
        return;
    }   
	if (WanMode != "IP_ROUTED")
    {
        return;
    }  
	setDisplay("WanDslite_checkboxRow", 1);
	if(getCheckVal("WanDslite_checkbox") == '1')
	{
		setDisplay("IPv6DSLiteRow", 1); 
	}
	setDisableByName("IPv6DSLite", 0);
	setDisable("WanDslite_checkbox", 0);
	for(i = 0; i < GetWanList().length;i++)
	{
	    if( GetWanList()[i].IPv6DSLite.toString() != "Off" && GetWanList()[i].domain != GetCurrentWan().domain)
		{
		    setDisableByName("IPv6DSLite", 1);
			setDisable("WanDslite_checkbox", 1);
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
	
	if(getCheckVal("WanDslite_checkbox") == '1')
	{
		setDisplay("IPv6AFTRNameRow", 1);
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
    setDisplay("Wan_802_1_P_selectRow", 0);
    setDisplay("PriorityPolicyRow", 0);
    if (GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("PriorityPolicyRow", 1);
    }
    if (PriorityPolicy.toUpperCase() == "SPECIFIED" && GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("Wan_802_1_P_selectRow", 1);
    }  
    if (PriorityPolicy.toUpperCase() == "COPYFROMIPPRECEDENCE"  && GetCurrentWan().EnableVlan.toString().toUpperCase() == "1")
    {
        setDisplay("DefaultVlanPriorityRow", 1);
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
	setDisable("WanUserName_text",Disable);
	setDisable("WanPassword_text",Disable);
	setDisable("IPv6AFTRName",Disable);
	setDisable("ButtonApply",Disable);
	setDisable("ButtonCancel",Disable);
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
    	setDisable("WanConnectMode_select", 0);
    }
    
    if (GetFeatureInfo().IPv6 == "0")
    {      
        setDisable("WanIP_Mode_select", 1);
        setSelect("WanIP_Mode_select", "IPv4");
    }

	E8Ctr069CheckDisable(Wan);
	ControlErrorWANCfg(Wan);
	
    return;
}

function OnChangeUI(ControlObject)
{
    var wanmodeobj = getElementById('WanConnectMode_select');
    ChangeUISource = ControlObject;
    if(ControlObject == wanmodeobj)
    {
        Controlsvrlist();
    }
    ControlPage(GetPageData());
    
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

function FillUserForm(Form, Wan)
{
    if (Wan.Mode == 'IP_Routed')
    {
        switch (Wan.IPv4AddressMode)
        {
            case 'PPPoE':
                Form.usingPrefix('y');	
                Form.addParameter('Username', Wan.UserName);
                Form.addParameter('Password', Wan.Password);
                Form.endPrefix();
                break;
        }
    }
	
	if(GetCfgMode().BJCU == "1" )
    {
    	Form.usingPrefix('y');	
		Form.addParameter('ConnectionType', Wan.Mode);
        Form.addParameter('NATEnabled', Wan.IPv4NATEnable);
        Form.endPrefix();
    }
}

function FillSysForm(Form, Wan)  
{
	var WanProtocolType = GetCurrentWan().ProtocolType.toString();
	var WanIPv6DSLite = GetCurrentWan().IPv6DSLite.toString();
	
	if(EditFlag == "ADD")
	{
		Form.usingPrefix('GROUP_a_y'); 
	}
	else if(EditFlag == "EDIT")
	{
		Form.usingPrefix('y');  
	}
	
	Form.addParameter('Enable',Wan.Enable); 
	Form.addParameter('X_HW_IPv4Enable',Wan.IPv4Enable); 
	Form.addParameter('X_HW_IPv6Enable',Wan.IPv6Enable);  
	
	if ("" == Wan.IPv6WanMVlanId)
	{
	    Form.addParameter('X_HW_IPv6MultiCastVLAN', -1);
	}
        else
	{
	    Form.addParameter('X_HW_IPv6MultiCastVLAN', Wan.IPv6WanMVlanId);
        }

	if(true == IsOldServerListType(Wan.ServiceList))
	{
		Form.addParameter('X_HW_SERVICELIST', Wan.ServiceList); 
		Form.addParameter('X_HW_ExServiceList', ''); 		
	}
	else
	{
		Form.addParameter('X_HW_SERVICELIST', 'INTERNET'); 
		Form.addParameter('X_HW_ExServiceList', Wan.ServiceList); 
	}
         
    Form.addParameter('X_HW_VLAN', Wan.EnableVlan == "1" ? Wan.VlanId:"0");   
    Form.addParameter('X_HW_PRI',Wan.Priority);
    Form.addParameter('X_HW_PriPolicy', (Wan.EnableVlan == "1") ? Wan.PriorityPolicy:"Specified"); 
    Form.addParameter('X_HW_DefaultPri', Wan.DefaultPriority); 
    Form.addParameter('ConnectionType',Wan.Mode);	
    if ( Wan.ServiceList.match('INTERNET') || Wan.ServiceList.match('IPTV') || Wan.ServiceList.match('OTHER') )
    {
        
        Form.addParameter('X_HW_LanDhcpEnable',Wan.EnableLanDhcp);		
    }
     
    if ( true == IsDstIPForwardingListVisibility(Wan,Wan.ServiceList) )
    {
    	Form.addParameter('X_HW_IPForwardList',Wan.DstIPForwardingList);
    }
    if (Wan.Mode.indexOf("Bridged") >= 0)
    {
	    if (EditFlag == "ADD")
	    {
        }

	    if ("" == Wan.IPv4WanMVlanId)
	    {
	        Form.addParameter('X_HW_MultiCastVLAN', 0xFFFFFFFF); 
	    }
        else
	    {
	        Form.addParameter('X_HW_MultiCastVLAN', Wan.IPv4WanMVlanId);
        }

    }
    else if (Wan.Mode == 'IP_Routed')
    {
        Form.addParameter('NATEnabled',(((Wan.ServiceList=="TR069" || Wan.ServiceList=="VOIP" || Wan.ServiceList=="TR069_VOIP")) ? "0" : Wan.IPv4NATEnable));

        if (Wan.IPv4NATEnable == "1")
        {
         	Form.addParameter('X_HW_NatType', Wan.NatType);      
        }
        
        if ("" == Wan.IPv4WanMVlanId)
        {
            Form.addParameter('X_HW_MultiCastVLAN', 0xFFFFFFFF);
        }
        else
        {
            Form.addParameter('X_HW_MultiCastVLAN', Wan.IPv4WanMVlanId);
        }
    }
	
                var DnsStr = Wan.IPv4PrimaryDNS + ',' + Wan.IPv4SecondaryDNS;
                if (Wan.IPv4PrimaryDNS.length == 0)
                {
                    DnsStr = Wan.IPv4SecondaryDNS;
		        }
                if (Wan.IPv4SecondaryDNS.length == 0)
                {
                    DnsStr = Wan.IPv4PrimaryDNS;
                }	

	if (Wan.Mode == 'IP_Routed')
	{
        switch (Wan.IPv4AddressMode)
        {
            case 'PPPoE':
                Form.addParameter('Username',Wan.UserName);
                Form.addParameter('Password',Wan.Password);
                if(!isE8cAndCMCC())
                {
                    Form.addParameter('X_HW_LcpEchoReqCheck',Wan.LcpEchoReqCheck);
                }
                if (Wan.Mode == 'IP_Routed' && Wan.ServiceList == 'INTERNET' && "1" == Wan.IPv4Enable)
                {
                    Form.addParameter('ConnectionTrigger',Wan.IPv4DialMode);
                    if (Wan.IPv4DialMode == "OnDemand")
                    {
                        Form.addParameter('IdleDisconnectTime',Wan.IPv4DialIdleTime); 
                        Form.addParameter('X_HW_IdleDetectMode',Wan.IPv4IdleDisconnectMode);
                    }
                }
                Form.addParameter('DNSEnabled', "1");
				
				if(Wan.IPv4MXU == "")
				{
					Form.addParameter('MaxMRUSize',"1492");
				}
				else
				{
					Form.addParameter('MaxMRUSize',Wan.IPv4MXU);
				} 
                break;
    					
            case 'Static':
                if("1" == Wan.IPv4Enable)
                {
                    Form.addParameter('AddressingType','Static');
                    Form.addParameter('ExternalIPAddress',Wan.IPv4IPAddress);
                    Form.addParameter('SubnetMask',Wan.IPv4SubnetMask);
                    Form.addParameter('DefaultGateway',Wan.IPv4Gateway);
    					
                    Form.addParameter('DNSServers',DnsStr);	
                    Form.addParameter('DNSEnabled', "1");

                }
				if(Wan.IPv4MXU == "")
				{
					Form.addParameter('MaxMTUSize',"1500");
				}
				else
				{
					Form.addParameter('MaxMTUSize',Wan.IPv4MXU);
				}
                break;
                
            case 'DHCP':
                if("1" == Wan.IPv4Enable)
                {
                    Form.addParameter('AddressingType','DHCP');
                    Form.addParameter('DNSEnabled', "1");
                    Form.addParameter('X_HW_VenderClassID',Wan.IPv4VendorId);
                    if(!isE8cAndCMCC())
                    {
                        Form.addParameter('X_HW_ClientID',Wan.IPv4ClientId);
                    }
                }
				if(Wan.IPv4MXU == "")
				{
					Form.addParameter('MaxMTUSize',"1500");
				}
				else
				{
					Form.addParameter('MaxMTUSize',Wan.IPv4MXU);
				}
                break;
            default:		
                break;
        }
    }
    Form.endPrefix();

    var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
    
    if(LanWanBindInfo == null && EditFlag == "EDIT" && IsE8C != 1)
    {
	Form.usingPrefix('Add_z'); 				
    }
    else
    {    
  	Form.usingPrefix('z');  
    }
    if ( Wan.ServiceList.match('INTERNET')
	|| Wan.ServiceList.match('IPTV')
	|| Wan.ServiceList.match('OTHER') )
    {   
		    for (var i = 1; i <= TopoInfo.EthNum; i++)
			{
				Form.addParameter('Lan'+i+'Enable', IsLanBind("Lan"+i, Wan.IPv4BindLanList)==true ? "1":"0");
			}

            for (var i = 1; i <= TopoInfo.SSIDNum; i++)
            {            
               if( i > 4)
               {
                   break;
               }
               Form.addParameter('SSID'+i+'Enable', IsLanBind("SSID"+i, Wan.IPv4BindLanList)==true ? "1":"0");
            }
    }
    Form.endPrefix();
    
    if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable)
    {   		    
		var IPv6AddressUrl = GetIPv6AddressAcquireInfo(Wan.domain);
		if(IPv6AddressUrl==null && EditFlag == "EDIT")
		{
			Form.usingPrefix(COMPLEX_CGI_PREFIX + 'm');	
		}
		else  
		{
		    Form.usingPrefix('m');
		}
		Form.addParameter('Alias','');
		Form.addParameter('Origin',Wan.IPv6AddressMode);
		Form.addParameter('IPAddress', Wan.IPv6IPAddress);
		Form.addParameter('ChildPrefixBits', Wan.IPv6AddressStuff);
		if(Wan.IPv6AddrMaskLenE8c == "")
		{
		    Form.addParameter('AddrMaskLen',"0");
		}
		else
		{
		    Form.addParameter('AddrMaskLen',Wan.IPv6AddrMaskLenE8c);
		}
		Form.addParameter('DefaultGateway',Wan.IPv6GatewayE8c);
		if ((Wan.EncapMode.toString().toUpperCase() == "IPOE") && (Wan.IPv6AddressMode == "None") && (Wan.IPv6ReserveAddress != ""))
		{
			if(!isE8cAndCMCC())
			{
				Form.addParameter('UnnumberredWanReserveAddress', Wan.IPv6ReserveAddress);
			}
		}
		Form.endPrefix();
    }
	
	if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable)
    { 		
		var IPv6PrefixUrl = GetIPv6PrefixAcquireInfo(Wan.domain);
		if(IPv6PrefixUrl==null && EditFlag == "EDIT")
		{                   
			Form.usingPrefix(COMPLEX_CGI_PREFIX + 'n');	
		}
		else
		{
		    Form.usingPrefix('n');
		}
		Form.addParameter('Alias','');
		
		Wan.IPv6PrefixMode = (Wan.EnablePrefix == "0")?"None":Wan.IPv6PrefixMode;
		Form.addParameter('Origin',Wan.IPv6PrefixMode);
		Form.addParameter('Prefix',Wan.IPv6StaticPrefix);
		Form.endPrefix();
    }
    
	if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable && Wan.IPv6AddressMode == "Static")
    { 		
		var DnsUrl = GetIPv6WanDnsServerInfo(domainTowanname(Wan.domain));
		if(DnsUrl==null && EditFlag == "EDIT")
		{
			Form.usingPrefix(COMPLEX_CGI_PREFIX+'k');	
			var DnsServer = GetWanDnsServerString(Wan.IPv6PrimaryDNS, Wan.IPv6SecondaryDNS);
			Form.addParameter('DNSServer',DnsServer);

			Form.addParameter('Interface',domainTowanname(Wan.domain));
			Form.endPrefix();
		}
		else
		{
		 			Form.usingPrefix('k');	
			var DnsServer = GetWanDnsServerString(Wan.IPv6PrimaryDNS, Wan.IPv6SecondaryDNS);
			Form.addParameter('DNSServer',DnsServer);
			Form.endPrefix();
		}
    }    	
	
	if (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed" )
	{
	  Form.usingPrefix('j');  
		if(Wan.EnableDSLite == "0")
		{
			Wan.IPv6DSLite = 'Off';
			Wan.IPv6AFTRName = "";
		}
		Form.addParameter('WorkMode',Wan.IPv6DSLite);
		Form.addParameter('AFTRName',Wan.IPv6AFTRName);
		Form.endPrefix();
	}

	if ( Wan.ProtocolType.toString() == "IPv4" && Wan.Mode == "IP_Routed" && true == Is6RdSupported())
	{
	    Form.usingPrefix('r');
		if ('Off' == Wan.RdMode)
		{
			Form.addParameter('Enable','0');  
		}
		else if('Dynamic' == Wan.RdMode)
		{
			Form.addParameter('Enable','1');  
			Form.addParameter('RdMode',Wan.RdMode);
		}
		else
		{
			Form.addParameter('Enable','1');  
			Form.addParameter('RdPrefix',Wan.RdPrefix);
			Form.addParameter('RdPrefixLen',Wan.RdPrefixLen);
			Form.addParameter('RdBRIPv4Address',Wan.RdBRIPv4Address);
			Form.addParameter('RdIPv4MaskLen',Wan.RdIPv4MaskLen);
			if (Wan.EncapMode.toString().toUpperCase() != "PPPOE")
			{
				Form.addParameter('RdMode',Wan.RdMode);
			}
		}

		Form.endPrefix();
    }
}

function FillForm(Form, Wan)  
{
    if (IsAdminUser())
        FillSysForm(Form, Wan);
    else
        FillUserForm(Form, Wan);
}

function CleanServiceListVoip()
{
    var ServiceList = document.getElementById("WanServiceList_select");
    var Length = ServiceList.options.length;
	var IsSupportVoice = '<%HW_WEB_GetFeatureSupport(HW_VSPA_FEATURE_VOIP);%>';
	
	if ('1' == IsSupportVoice)
	{
		return true;
	}
	
    for (var i = Length; i >=0; i--)
    {
        try
        {
            var Child = ServiceList.options[i];
            if (Child == undefined)
            {
               continue;
            }
            
            if ((Child.value.toString().toUpperCase() == "VOIP" 
               || Child.value.toString().toUpperCase() == "TR069_VOIP" 
               || Child.value.toString().toUpperCase() == "VOIP_INTERNET"
               || Child.value.toString().toUpperCase() == "TR069_VOIP_INTERNET"
			   || Child.value.toString().toUpperCase() == "VOIP_IPTV" 
			   || Child.value.toString().toUpperCase() == "TR069_VOIP_IPTV")
			   && (selctIndex == -1))
            {
                ServiceList.remove(i);        
            }			
        }
        catch(ex)
        {
        }
    }
}


function GetSelectWan(wanname)
{
	var WanResult = new Array();
	var WanList = GetWanList();
	for(var i = 0; i < WanList.length; i++)
	{
		if(domainTowanname(WanList[i].domain) == wanname)
		{
			WanResult = WanList[i];
			return WanResult;
		}
	}
	return null;
}
function GetWanInfoSelected()
{
	var Control = document.getElementById("WanConnectName_select");
	if (Control == null)
	{
	    return null;
	}
	var SelectWan = GetSelectWan(Control.value);
	return SelectWan;
}	

function btnAddWanCnt()
{
	CurrentWan = defaultWan.clone();

	var wanInfoTmp = null;
    if (AddType == 2)
	{
	    wanInfoTmp = GetWanInfoSelected();
		if (wanInfoTmp == null)
		{
		    return null;
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


function ControlWanNewConnection()
{
	var Control = getElById("WanConnectName_select");
	if(Control.value == 'New')
	{
		AddType = 1;
	}
	else
	{
		AddType = 2;
	}
	
}
