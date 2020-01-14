<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="Pragma" content="no-cache" />
	<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
    <title>WAN Configuration</title>
    
    <style>
    .TextBox
    {
        width:150px;  
    }
    .Select
    {
        width:157px;  
    }
    .TextArea
    {
        width:475px;  
    }
    </style>
</head>

<script>
function doKey(e){   
    var ev = e || window.event;
    var obj = ev.target || ev.srcElement;
    var t = obj.type || obj.getAttribute('type');

    if(ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea"){   
        return false;   
    }   
}

document.onkeypress=doKey;   

document.onkeydown=doKey;   

function NeedClearWanIPv4Info(Wan)
{
	if ("1" == Wan.IPv4Enable && Wan.Mode == 'IP_Routed' && Wan.IPv4AddressMode == 'Static')
		return false;
	else
		return true;
}

function NeedClearWanIPv6AddressInfo(Wan)
{
	if ("1" == Wan.IPv6Enable && Wan.Mode == 'IP_Routed' && Wan.IPv6AddressMode == "Static")
		return false;
	else
		return true;
}

function NeedClearWanIPv6PrefixInfo(Wan)
{
	if ("1" == Wan.IPv6Enable && Wan.Mode == 'IP_Routed' && Wan.IPv6PrefixMode == "Static")
		return false;
	else
		return true;
}

function ModifyWanData(Wan)
{

	if(true == NeedClearWanIPv4Info(Wan))
	{
		Wan.IPv4IPAddress    = "";
		Wan.IPv4SubnetMask   = "";
		Wan.IPv4Gateway      = "";
		Wan.IPv4PrimaryDNS   = "";
		Wan.IPv4SecondaryDNS = "";
	}

	if(true == NeedClearWanIPv6AddressInfo(Wan))
	{
		Wan.IPv6IPAddress    = "";
		Wan.IPv6PrimaryDNS   = "";
		Wan.IPv6SecondaryDNS = "";
		Wan.IPv6AddrMaskLenE8c   = "";
		Wan.IPv6GatewayE8c = "";
	}
	
	if(true == NeedClearWanIPv6PrefixInfo(Wan))
	{
		Wan.IPv6StaticPrefix = "";
	}
}
var curEnterStyle = "";
if(window.location.href.indexOf("wane8c.asp?") > 0)
{
	var currentUrl = window.location.href;
	var tempId = (currentUrl.split("?"))[1];
	if(tempId != "")
	{
		curEnterStyle = "Link";
	}
}
else
{
	curEnterStyle = "Direct";
}

function GetCurrentLinkWan()
{
	var curUrl = window.location.href;
	var curMacId = (curUrl.split("?"))[1];
	var Wan = GetWanList();
	for(var i = 0; i < Wan.length; i++)
	{
		if (Wan[i].MacId == curMacId )
		{
		    return domainTowanname(Wan[i].domain);
		}
	}
	return null;
}

function LoadFrame()
{
	ModifyWanList(ModifyWanData);
	ControlWanNameList();
	DisplayConfigPanel(1);
	ControlWanNewConnection();
	if(curEnterStyle == "Link")
	{
		var curLinkWan = GetCurrentLinkWan();
		if(curLinkWan != null)
		{
			setSelect("WanConnectName_select",curLinkWan);
		}
	}
	ControlWanPage();
	WanSelectControl();
	
}
</script>

<body  class="mainbody" onLoad="LoadFrame();" >
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../../bbsp/common/managemode.asp"></script>
<script language="javascript" src="../../bbsp/common/wanaddressacquire.asp"></script>
<script language="javascript" src="../../bbsp/common/wandns.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../../bbsp/common/lanmodelist.asp"></script>
<script language="javascript" src="../../bbsp/common/wanpageparse.asp"></script>
<script language="javascript" src="../../bbsp/common/wandatabind.asp"></script>
<script language="javascript" src="../../bbsp/common/wancontrole8c.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_check.asp"></script>
<script language="javascript" src="<%HW_WEB_CleanCache_Resource(wanlanguage.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var Wan = GetWanList();
var IsSurportPolicyRoute  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_ROUTE_POLICY);%>";
var DoubleFreqFlag = <%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>;  
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

function IsAdminUser()
{
    return (curUserType == sysUserType);
}

function TopoInfoClass(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}

var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfoClass);%>
var TopoInfo = TopoInfoList[0];

function GetTopoInfo()
{
    return TopoInfo;
}
function GetTopoItemValue(Name)
{
    return TopoInfo[Name];
}

</script>
<div id="PromptPanel">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td class="prompt">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class='title_common'>

                            <script>document.write(GetLanguage("WanHeadDescription"));</script>

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class='height5p'>
            </td>
        </tr>
    </table>
</div>

<script>
var gWanMode = 'IP_Routed';
								
function setControl(Index)
{
   setDisable("ButtonApply", "0");
   setDisable("ButtonNewWan", "0");
   if (-1 == Index)
   {
        var CurrentWan = new WanInfoInst(); 
        
       	var IPProtVer = GetIPProtVerMode();
		if (2 == IPProtVer)
		{
			CurrentWan.ProtocolType = "IPv6";
			CurrentWan.IPv4Enable = "0";
			CurrentWan.IPv6Enable = "1";
		}
		
		if(GetRunningMode() == "1")
		{
			CurrentWan.VlanId = "1";
			CurrentWan.UserName = "";
			CurrentWan.Password = "";
		}
        EditFlag = "ADD";
        ChangeUISource = null;
		gWanMode = CurrentWan.Mode;
		
		var AddWanCnt = btnAddWanCnt();
		if (true == AddWanCnt)
		{
			var wanInfoTmp = null;
			wanInfoTmp = GetWanInfoSelected();

			CurrentWan.EnableVlan = wanInfoTmp.EnableVlan;
			CurrentWan.VlanId = wanInfoTmp.VlanId ;
			CurrentWan.PriorityPolicy = wanInfoTmp.PriorityPolicy;
			CurrentWan.Priority = wanInfoTmp.Priority;
			CurrentWan.DefaultPriority = wanInfoTmp.DefaultPriority;
		}
		else if (false == AddWanCnt)
		{
			EditFlag = "EDIT";
			ChangeUISource = null;
			return false;
		}

        BindPageData(CurrentWan);
        ControlPage(CurrentWan);
        displaysvrlist();
        DisplayConfigPanel(1);
   }
   else
   {
        var Feature = GetFeatureInfo();
        if (Feature.IPProtChk == 1)
        {
			var protoType = getElementById('WanIP_Mode_select');
            protoType.options.length = 0;
			protoType.options.add(new Option(Languages['IPv4'],'IPv4'));
			protoType.options.add(new Option(Languages['IPv6'],'IPv6'));	
			protoType.options.add(new Option(Languages['IPv4IPv6e8c'],'IPv4/IPv6')); 
		}

		var CurrentWan = GetWanInfoSelected();
		gWanMode = CurrentWan.Mode;
        EditFlag = "EDIT";
        BindPageData(CurrentWan);
        ControlPage(CurrentWan);
        DisplayConfigPanel(1);
   }

	displayProtocolType();
	displayWanMode();
}

function ControlWanNameList()
{
	var Control = getElById("WanConnectName_select");
	var WanList = GetWanList();
    var i = 0;
    Control.options.length = 0;
	
    for (i = 0; i < WanList.length; i++)
    {    
        var Option = document.createElement("Option");
        Option.value = domainTowanname(WanList[i].domain);
        Option.innerText = MakeWanName1(WanList[i]);
        Option.text = MakeWanName1(WanList[i]);
        Control.appendChild(Option);
    }
	if(WanList.length == 0)
	{
		var NullOption = document.createElement("Option");
		NullOption.value = 'New';
		NullOption.innerText = '';
		NullOption.text = '';
		Control.appendChild(NullOption);
	}
}

function ControlWanPage()
{
	var Control = getElById("WanConnectName_select");
	if(Control.value == 'New')
	{
		
		setControl(-1);	
		setDisable("ButtonNew", "1"); 
		return;
	}
	else
	{
		var SelectWan = GetSelectWan(Control.value);
		if(IsTr069WanOnlyRead() && (SelectWan.ServiceList.indexOf("TR069") >= 0))
		{
			setDisable("ButtonDelete", 1);
			setDisable("ButtonNew", 1);
		}
		else
		{
			setDisable("ButtonDelete", 0);
			setDisable("ButtonNew", 0);
		}
		
		setControl(-2);	
	}
	
}
function ClickAddWan()
{	
	if(GetWanList().length >= 8)
	{
		AlertMsg("WanIsFull");
		return false;    
	}
	var Control = getElById("WanConnectName_select");
	if(Control.value == 'New')
	{
		return;
	}
	else
	{
		setControl(-1);	
	}
	
}

function isExistOptionNew()
{
	var objSelect = getElById("WanConnectName_select");
	for(var i = 0; i < objSelect.options.length; i++)
	{
		if(objSelect.options[i].value == 'New')
		{
			return true;
		}
	}
	return false;
}

function ClickNewWan()
{
	if(GetWanList().length >= 8)
	{
		AlertMsg("WanIsFull");
		return false;    
	}
	var Control = getElById("WanConnectName_select");
	if(!isExistOptionNew())
	{
		var NullOption = document.createElement("Option");
		NullOption.value = 'New';
		NullOption.innerText = '';
		NullOption.text = '';
		Control.appendChild(NullOption);
	}
	setSelect("WanConnectName_select",'New');
	WanSelectControl();
	setDisable("ButtonApply", "0");
}

function DisplayConfigPanel(Flag)
{
    setDisplay("ConfigPanel", Flag); 
    setDisplay("ConfigPanelButtons", Flag);  
}
function OnAddApply()
{
    var Wan = GetPageData();
	var FeatureInfo = GetFeatureInfo();
    
    if (CheckWan(Wan) == false)
    {
        return false;
    }

    if (CheckForSession(Wan, GetAddType()) == false)
    {
        return false;
    }

    
    setDisable("ButtonApply", "1");
	setDisable("ButtonDelete", "1");
	setDisable("ButtonNew", "1");
	setDisable("ButtonNewWan", "1");
    
    var Form = new webSubmitForm();
    FillForm(Form, Wan);
    
    var DnsUrl = (Wan.IPv6AddressMode=="Static") ? "&k=GROUP_a_y.X_HW_IPv6.IPv6DnsServer" : "";
    var IPv6Path = (Wan.IPv6Enable == "1") ? ('&m=GROUP_a_y.X_HW_IPv6.IPv6Address&n=GROUP_a_y.X_HW_IPv6.IPv6Prefix'+DnsUrl) : '';
    var DSLite = (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed") ? ('&j=GROUP_a_y.X_HW_IPv6.DSLite') : '';
    var Path6Rd = (true == Is6RdSupported()) ? ('&r=GROUP_a_y.X_HW_6RDTunnel') : '';
	var LanBind = "";
	
	if(!DoubleFreqFlag)
	{
		if (Wan.EncapMode.toString().toUpperCase() == "PPPOE")
		{
			if (FeatureInfo.LanPppWanBind != 0)
			{
				LanBind = "&z=GROUP_a_y.X_HW_LANBIND";
			}
		}
		else
		{
			if (FeatureInfo.LanSsidWanBind != 0)
			{
				LanBind = "&z=GROUP_a_y.X_HW_LANBIND";
			}
		}
	}
	else
	{   
	    if(IsSurportPolicyRoute == 1 &&
	      ( Wan.ServiceList.match('INTERNET')
		|| Wan.ServiceList.match('IPTV')
		|| Wan.ServiceList.match('OTHER')))
	    {
	        LanBind = "&z=InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route";     
	    }
	    else
	    {
	        LanBind = "";
	    }
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    var Url = 'addcfg.cgi?' + GetAddWanUrl(Wan) + LanBind + IPv6Path + DSLite + Path6Rd +'&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';
    Form.setAction(Url);
    Form.submit();
}

function addParamForBroWan(Form, wan)
{
	Form.usingPrefix('u');
    Form.addParameter('X_HW_VLAN', wan.VlanId);
    Form.addParameter('X_HW_PriPolicy',wan.PriorityPolicy);
    Form.addParameter('X_HW_PRI',wan.Priority);
	Form.addParameter('X_HW_DefaultPri', wan.DefaultPriority);
    Form.endPrefix();
}

function OnEditApply()
{
    var Wan = GetPageData();	
	
	var CurrentWan = GetWanInfoSelected();

    if (CheckWan(Wan) == false)
    {
        return false;
    }
	
	if (CheckWanSet(Wan) == false)
	{
		return false;
	}
	
	if (gWanMode != Wan.Mode && Wan.Mode == 'IP_Routed')
	{	
		Wan.IPv4NATEnable = 1;
	}
    
    setDisable("ButtonApply", "1");
	setDisable("ButtonDelete", "1");
	setDisable("ButtonNew", "1");
	setDisable("ButtonNewWan", "1");	
    
    var Form = new webSubmitForm();
    FillForm(Form, Wan);
    
    var IPv6PrefixUrl = GetIPv6PrefixAcquireInfo(Wan.domain);    
	if (IPv6PrefixUrl == null && "IP_Routed" == Wan.Mode && "1" == Wan.IPv6Enable)
	{
		IPv6PrefixUrl = "&"+COMPLEX_CGI_PREFIX+"n=" +  Wan.domain + ".X_HW_IPv6.IPv6Prefix";
	}	
	else
	{
		IPv6PrefixUrl = (IPv6PrefixUrl == null) ? "" : ("&n="+IPv6PrefixUrl.domain);
	}	
    
    var IPv6addressUrl = GetIPv6AddressAcquireInfo(Wan.domain);
	if (IPv6addressUrl == null && "IP_Routed" == Wan.Mode && "1" == Wan.IPv6Enable)
	{
		IPv6addressUrl = "&"+COMPLEX_CGI_PREFIX+"m=" +  Wan.domain + ".X_HW_IPv6.IPv6Address";
	}	
	else
	{
		IPv6addressUrl = (IPv6addressUrl == null) ? "" : ("&m="+IPv6addressUrl.domain);
	}
	
    var DnsUrl = GetIPv6WanDnsServerInfo(domainTowanname(Wan.domain));
	  if (Wan.Mode == 'IP_Routed' && Wan.IPv6AddressMode=="Static" && DnsUrl == null)
	  {
		    DnsUrl = "&"+COMPLEX_CGI_PREFIX+"k=InternetGatewayDevice.X_HW_DNS.Client.Server";
	  }
	  else
	  {
		    DnsUrl = (DnsUrl == null) ? "" : ("&k="+DnsUrl.domain);
		    DnsUrl = (Wan.IPv6AddressMode=="Static") ? DnsUrl : "";
	  }

	var CurrentWan = GetWanInfoSelected();
	var broWan = GetBrotherWan(CurrentWan);
	var FlagForAddBroWan = false;
	
	var FeatureInfo = GetFeatureInfo();
	var LanBind = "";
	
	if(!DoubleFreqFlag)
	{
		if (Wan.EncapMode.toString().toUpperCase() == "PPPOE")
		{
			if (FeatureInfo.LanPppWanBind != 0)
			{
				LanBind = '.X_HW_LANBIND';
			}
		}
		else
		{
			if (FeatureInfo.LanSsidWanBind != 0)
			{
				LanBind = '.X_HW_LANBIND';
			}
		}
	}
	else
	{
	    LanBind = "";
		var str = "";
		var str2 = "";
		var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
		if(LanWanBindInfo == null)
		{
			str = "&Add_z=";
			str2 = "InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route";   			
		}
		else
		{
			str = "&z=";
			str2 = LanWanBindInfo.Domain;
		}
	}
	
	var DSLite = (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed") ? ('.X_HW_IPv6.DSLite') : '';
	var Path6Rd = (true == Is6RdSupported()) ? ('.X_HW_6RDTunnel') : '';
	if (((CurrentWan.VlanId != Wan.VlanId)
	  || (CurrentWan.PriorityPolicy != Wan.PriorityPolicy)
	  || (CurrentWan.EnableVlan != Wan.EnableVlan)
      || ((Wan.PriorityPolicy.toUpperCase() == 'SPECIFIED' ) && (CurrentWan.Priority != Wan.Priority))
	  || ((Wan.PriorityPolicy.toUpperCase() != 'SPECIFIED' ) && (CurrentWan.DefaultPriority != Wan.DefaultPriority)))
	  && (broWan != null))
	{
		var prompt = GetLanguage("brothwan") + MakeWanName(broWan) + GetLanguage("browanvlan");
		if (false == ConfirmEx(prompt))
		{
			return;
		}
		broWan.EnableVlan = Wan.EnableVlan;
		
		

		if (Wan.EnableVlan == "1")
		{
		  broWan.VlanId = Wan.VlanId;
				broWan.Priority = Wan.Priority;
		}
		else
		{
    	broWan.VlanId = 0;
			broWan.Priority = 0;
		}
		
		broWan.PriorityPolicy = Wan.PriorityPolicy;
		
		broWan.DefaultPriority = Wan.DefaultPriority;
		
		FlagForAddBroWan = true;
		

		if(!DoubleFreqFlag)
		{
			var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ '&z=' + Wan.domain + LanBind
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite 
					+ '&r=' + Wan.domain + Path6Rd
					+ '&u=' + broWan.domain
					+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';
		}
		else
		{ 
		    if(IsSurportPolicyRoute == 1)
		    {
			    var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ str + str2
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite
					+ '&r=' + Wan.domain + Path6Rd
					+ '&u=' + broWan.domain
					+ '&RequestFile=html/bbsp/wan/confirm_wane8ccfginfo.html';   
			}
			else
			{     
			    var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite
					+ '&r=' + Wan.domain + Path6Rd
					+ '&u=' + broWan.domain
					+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';   			
			}
		}
	}
	else
	{
		if(!DoubleFreqFlag)
		{
			var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ '&z=' + Wan.domain + LanBind
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite
					+ '&r=' + Wan.domain + Path6Rd
					+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';
		}
		else
		{       
		    if(IsSurportPolicyRoute == 1)
		    {
			var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ str + str2
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite
					+ '&r=' + Wan.domain + Path6Rd
					+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';  
		    }
		    else
		    {
		    	var Url = 'complex.cgi?'
					+ 'y=' + Wan.domain
					+ IPv6PrefixUrl
					+ IPv6addressUrl
					+ DnsUrl
					+ '&j=' + Wan.domain + DSLite
					+ '&r=' + Wan.domain + Path6Rd
					+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html'; 
		    }
		}
	}
	
	if (FlagForAddBroWan == true)
	{
	    addParamForBroWan(Form, broWan);
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction(Url);
    Form.submit();
}

function OnEditApplyOmitBrother()
{
    var Wan = GetPageData();	
	
	var CurrentWan = GetWanInfoSelected();
	
    if (CheckWan(Wan) == false)
    {
        return false;
    }
	
    if (CheckWanSet(Wan) == false)
    {
        return false;
    }
	
	if (gWanMode != Wan.Mode && Wan.Mode == 'IP_Routed')
	{	
		Wan.IPv4NATEnable = 1;
	}
    
    setDisable("ButtonApply", "1");
	setDisable("ButtonDelete", "1");
	setDisable("ButtonNew", "1");
	setDisable("ButtonNewWan", "1");
    
    var Form = new webSubmitForm();
    FillForm(Form, Wan);
    
    var IPv6PrefixUrl = GetIPv6PrefixAcquireInfo(Wan.domain);    
    if (IPv6PrefixUrl == null && "IP_Routed" == Wan.Mode && "1" == Wan.IPv6Enable)
    {
        IPv6PrefixUrl = "&"+COMPLEX_CGI_PREFIX+"n=" +  Wan.domain + ".X_HW_IPv6.IPv6Prefix";
    }	
    else
    {
	IPv6PrefixUrl = (IPv6PrefixUrl == null) ? "" : ("&n="+IPv6PrefixUrl.domain);
    }	
    
    var IPv6addressUrl = GetIPv6AddressAcquireInfo(Wan.domain);
    if (IPv6addressUrl == null && "IP_Routed" == Wan.Mode && "1" == Wan.IPv6Enable)
    {
        IPv6addressUrl = "&"+COMPLEX_CGI_PREFIX+"m=" +  Wan.domain + ".X_HW_IPv6.IPv6Address";
    }	
    else
    {
        IPv6addressUrl = (IPv6addressUrl == null) ? "" : ("&m="+IPv6addressUrl.domain);
    }
	
    var DnsUrl = GetIPv6WanDnsServerInfo(domainTowanname(Wan.domain));
    if (Wan.Mode == 'IP_Routed' && Wan.IPv6AddressMode=="Static" && DnsUrl == null)
    {
        DnsUrl = "&"+COMPLEX_CGI_PREFIX+"k=InternetGatewayDevice.X_HW_DNS.Client.Server";
    }
    else
    {
        DnsUrl = (DnsUrl == null) ? "" : ("&k="+DnsUrl.domain);
        DnsUrl = (Wan.IPv6AddressMode=="Static") ? DnsUrl : "";
    }


    var FeatureInfo = GetFeatureInfo();
    var LanBind = "";
    if(!DoubleFreqFlag)
    {
		if (Wan.EncapMode.toString().toUpperCase() == "PPPOE")
		{
			if (FeatureInfo.LanPppWanBind != 0)
			{
				LanBind = '.X_HW_LANBIND';
			}
		}
		else
		{
			if (FeatureInfo.LanSsidWanBind != 0)
			{
					LanBind = '.X_HW_LANBIND';
			}
		}
    }
    else
    {
        LanBind = "";
    }
    if(DoubleFreqFlag)
    {
        var str = "";
        var str2 = "";
        var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));
        if(LanWanBindInfo == null)
        {
            str = "&Add_z=";
            str2 = "InternetGatewayDevice.Layer3Forwarding.X_HW_policy_route";   			
        }
        else
        {
            str = "&z=";
            str2 = LanWanBindInfo.Domain;
        }
    }
    var DSLite = (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed") ? ('.X_HW_IPv6.DSLite') : '';
    if(!DoubleFreqFlag)
    {
        var Url = 'complex.cgi?'
			+ 'y=' + Wan.domain
			+ '&z=' + Wan.domain + LanBind
			+ IPv6PrefixUrl
			+ IPv6addressUrl
			+ DnsUrl
			+ '&j=' + Wan.domain + DSLite
			+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';
    }
    else
    {       
        if(IsSurportPolicyRoute == 1)
		{
            var Url = 'complex.cgi?'
				+ 'y=' + Wan.domain
				+ str + str2
				+ IPv6PrefixUrl
				+ IPv6addressUrl
				+ DnsUrl
				+ '&j=' + Wan.domain + DSLite
				+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html';  
        }
        else
        {
	    	var Url = 'complex.cgi?'
				+ 'y=' + Wan.domain
				+ IPv6PrefixUrl
				+ IPv6addressUrl
				+ DnsUrl
				+ '&j=' + Wan.domain + DSLite
				+ '&RequestFile=html/bbsp/wan/confirmwane8ccfginfo.html'; 
        }
    }
    Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction(Url);
    Form.submit();
}

function OnApply()
{   
    if (EditFlag == "ADD")
    {
        OnAddApply();
        return;
    }
    var SessionVlanLimit  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_MULT_SESSION_VLAN_LIMIT);%>";
    if (SessionVlanLimit == 1)
    {
        OnEditApply();
    }
    else
    {
        OnEditApplyOmitBrother();
    }
}

function OnDelete()
{
    var Control = getElById("WanConnectName_select");
	if(Control.value == 'New')
	{
		return;
	}
	setDisable("ButtonApply", "1");
    setDisable("ButtonDelete", "1"); 
	setDisable("ButtonNew", "1");
	setDisable("ButtonNewWan", "1");	
	
	if(!DoubleFreqFlag)
	{
		var Form = new webSubmitForm();
		Form.addParameter(GetWanInfoSelected().domain,'');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wane8c.asp');
	}
	else
	{
		var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));

		var Form = new webSubmitForm();
		Form.addParameter(GetWanInfoSelected().domain,'');
		if(LanWanBindInfo != null)
		{

		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    	Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wane8c.asp');
	}
	Form.submit();
	DisableRepeatSubmit();
}

</script>

<form id="ConfigForm">
<table id="ConfigPanel"  width="100%" cellspacing="0" cellpadding="0"> 
<tr>
	<td class="table_left width_25p">连接名称</td> 
	<td class="table_right width_75p"> <select id="WanConnectName_select" class="Select" onchange="WanSelectControl()"> </select></td> 
</tr> 
<li   id="WanDomain"                 RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="domain"             InitValue="Empty"/>
<li   id="WanSwitch"                 RealType="CheckBox"           DescRef="EnableWanConnectione8c"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Enable"             InitValue="Empty"/>
<li   id="WanAddress_select"         RealType="DropDownList"       DescRef="EncapModee8c"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="EncapMode"          InitValue="[{TextRef:'IPoE',Value:'IPoE'},{TextRef:'PPPoE',Value:'PPPoE'}]"/>
<li   id="WanServiceList_select"     RealType="DropDownList"       DescRef="WanServiceListe8c"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="ServiceList"        InitValue="[{TextRef:'TR069',Value:'TR069'},{TextRef:'INTERNET',Value:'INTERNET'},{TextRef:'TR069_INTERNET',Value:'TR069_INTERNET'},{TextRef:'VOIP',Value:'VOIP'},{TextRef:'TR069_VOIP',Value:'TR069_VOIP'},{TextRef:'VOIP_INTERNET',Value:'VOIP_INTERNET'},{TextRef:'TR069_VOIP_INTERNET',Value:'TR069_VOIP_INTERNET'},{TextRef:'IPTV',Value:'IPTV'},{TextRef:'OTHER',Value:'OTHER'}, {TextRef:'VOIP_IPTV',Value:'VOIP_IPTV'}, {TextRef:'TR069_IPTV',Value:'TR069_IPTV'},{TextRef:'TR069_VOIP_IPTV',Value:'TR069_VOIP_IPTV'}]"/>
<li   id="WanConnectMode_select"     RealType="DropDownList"       DescRef="WanModee8c"                   RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Mode"               InitValue="[{TextRef:'WanModeRoute',Value:'IP_Routed'},{TextRef:'WanModeBridge',Value:'IP_Bridged'}]"/>
<li   id="WanIP_Mode_select"         RealType="DropDownList"       DescRef="WanProtocolTypee8c"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="ProtocolType"       InitValue="[{TextRef:'IPv4',Value:'IPv4'},{TextRef:'IPv6',Value:'IPv6'},{TextRef:'IPv4IPv6e8c',Value:'IPv4/IPv6'}]"/>
<li   id="WanUserName_text"          RealType="TextBox"            DescRef="IPv4UserNamee8c"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="UserName"           InitValue="Empty"   MaxLength="63"/>
<li   id="WanPassword_text"          RealType="TextBox"            DescRef="IPv4Passworde8c"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Password"           InitValue="Empty"   MaxLength="63"/>
<li   id="WanMTU_text"               RealType="TextBox"            DescRef="IPv4MXUe8c"                   RemarkRef="IPv4MXUHELP"        ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4MXU"            InitValue="Empty"/>
<li   id="WanVlan_Enable"            RealType="CheckBox"           DescRef="EnableVlane8c"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="EnableVlan"         InitValue="Empty"/>
<li   id="WanVlanID_text"            RealType="TextBox"            DescRef="VlanIde8c"                    RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="VlanId"             InitValue="Empty"/>

<li   id="PriorityPolicy"            RealType="RadioButtonList"    DescRef="PriorityPolicye8c"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="PriorityPolicy"     InitValue="[{TextRef:'Specified',Value:'Specified'},{TextRef:'CopyFromIPPrecedence',Value:'CopyFromIPPrecedence'}]"/>
<li   id="DefaultVlanPriority"       RealType="DropDownList"       DescRef="DefaultVlanPrioritye8c"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="DefaultPriority"    InitValue="[{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]"/>

<li   id="Wan_802_1_P_select"        RealType="DropDownList"       DescRef="VlanPrioritye8c"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Priority"           InitValue="[{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]"/>
<li   id="LcpEchoReqCheck"           RealType="CheckBox"           DescRef="LcpEchoReqChecke8c"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="LcpEchoReqCheck"    InitValue="Empty"/>
<li   id="Wan_Port_checkbox"         RealType="CheckBoxList"       DescRef="IPv4LanBindOptionse8c"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4BindLanList"    InitValue="[{TextRef:'LAN1e8c',Value:'LAN1'},{TextRef:'LAN2e8c',Value:'LAN2'},{TextRef:'LAN3e8c',Value:'LAN3'},{TextRef:'LAN4e8c',Value:'LAN4'}]"/>                                                                   
<li   id="Wan_SSID_checkbox"         RealType="CheckBoxList"       DescRef="IPv4SSIDBindOptions"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4BindSsidList"    InitValue="[{TextRef:'SSID1e8c',Value:'SSID1'},{TextRef:'SSID2',Value:'SSID2'},{TextRef:'SSID3',Value:'SSID3'},{TextRef:'SSID4',Value:'SSID4'},{TextRef:'SSID5',Value:'SSID5'},{TextRef:'SSID6',Value:'SSID6'},{TextRef:'SSID7',Value:'SSID7'},{TextRef:'SSID8',Value:'SSID8'}]"/>                                                                   
<li   id="DstIPForwardingList"       RealType="TextArea"           DescRef="DstIPForwardingCfge8c"        RemarkRef="DstIPForwardingHelp"  ErrorMsgRef="Empty"    Require="FALSE"    BindField="DstIPForwardingList" InitValue="Empty" MaxLength="8192"/>

<li   id="WanIPv4InfoBar"            RealType="HorizonBar"         DescRef="WanIPv4Info"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
<li   id="WanIPv4Address_select"     RealType="DropDownList"       DescRef="WanIpModee8c"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4AddressMode"    InitValue="[{TextRef:'DHCP',Value:'DHCP'},{TextRef:'Static',Value:'Static'},{TextRef:'PPPoE',Value:'PPPoE'}]"/>
<li   id="IPv4NatSwitch"             RealType="CheckBox"           DescRef="EnableNate8c"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4NATEnable"      InitValue="Empty"/>
<li   id="IPv4NatType"               RealType="DropDownList"       DescRef="NatTypee8c"                   RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="NatType"            InitValue="[{TextRef:'Port_Restricted_Cone_NAT',Value:'0'},{TextRef:'Full_Cone_NAT',Value:'1'}]"/>
<li   id="IPv4VendorId"              RealType="TextBox"            DescRef="IPv4VendorIde8c"              RemarkRef="IPv4VendorIdDes"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4VendorId"       InitValue="Empty"   MaxLength="63"/>
<li   id="IPv4ClientId"              RealType="TextBox"            DescRef="IPv4ClientIde8c"              RemarkRef="IPv4ClientIdDes"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4ClientId"       InitValue="Empty"   MaxLength="63"/>
<li   id="WanIPv4Address_text"       RealType="TextBox"            DescRef="IPv4IPAddresse8c"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv4IPAddress"      InitValue="Empty"/>
<li   id="WanSubmask_text"           RealType="TextBox"            DescRef="IPv4SubnetMaske8c"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv4SubnetMask"     InitValue="Empty"/>
<li   id="WanGateway_text"           RealType="TextBox"            DescRef="IPv4DefaultGatewaye8c"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv4Gateway"        InitValue="Empty"/>
<li   id="WanPri_DNS_text"           RealType="TextBox"            DescRef="IPv4PrimaryDNSe8c"      RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4PrimaryDNS"     InitValue="Empty"/>
<li   id="WanSec_DNS_text"           RealType="TextBox"            DescRef="IPv4SecondaryDNSe8c"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4SecondaryDNS"   InitValue="Empty"/>
<li   id="IPv4DialMode"              RealType="DropDownList"       DescRef="IPv4DialModee8c"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4DialMode"       InitValue="[{TextRef:'IPv4DialModeAlwaysOn',Value:'AlwaysOn'},{TextRef:'IPv4DialModeManual',Value:'Manual'},{TextRef:'IPv4DialModeOnDemand',Value:'OnDemand'}]"/>
<li   id="IPv4DialIdleTime"          RealType="TextBox"            DescRef="IPv4IdleTimee8c"              RemarkRef="IPv4IdleTimeRemark" ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv4DialIdleTime"   InitValue="Empty"/>
<li   id="IPv4IdleDisconnectMode"    RealType="DropDownList"       DescRef="IPv4IdleDisconnectModee8c"    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4IdleDisconnectMode"   InitValue="[{TextRef:'IPv4IdleDisconnectMode_note1',Value:'DetectBidirectionally'},{TextRef:'IPv4IdleDisconnectMode_note2',Value:'DetectUpstream'}]"/>
<li   id="IPv4WanMVlanId"            RealType="TextBox"            DescRef="WanMVlanIde8c"                RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv4WanMVlanId"     InitValue="Empty"/>
<li   id="LanDhcpSwitch"             RealType="CheckBox"           DescRef="EnableLanDhcpe8c"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="EnableLanDhcp"      InitValue="Empty"/>
<li   id="RDMode"                    RealType="RadioButtonList"    DescRef="Des6RDModee8c"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="RdMode"              InitValue="[{TextRef:'Off',Value:'Off'},{TextRef:'Auto',Value:'Dynamic'},{TextRef:'Static',Value:'Static'}]"/>
<li   id="RdPrefix"                  RealType="TextBox"            DescRef="Des6RDPrefixe8c"              RemarkRef="Empty"       ErrorMsgRef="Empty"    Require="TRUE"     BindField="RdPrefix"              InitValue="Empty"/>
<li   id="RdPrefixLen"               RealType="TextBox"            DescRef="Des6RDPrefixLenthe8c"         RemarkRef="RDPreLenthReMark"   ErrorMsgRef="Empty"    Require="TRUE"     BindField="RdPrefixLen"              InitValue="Empty"/>
<li   id="RdBRIPv4Address"           RealType="TextBox"            DescRef="Des6RDBrAddre8c"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="RdBRIPv4Address"              InitValue="Empty"/>
<li   id="RdIPv4MaskLen"             RealType="TextBox"            DescRef="Des6RDIpv4MaskLenthe8c"       RemarkRef="RDIpv4MskLnReMark"  ErrorMsgRef="Empty"    Require="TRUE"     BindField="RdIPv4MaskLen"              InitValue="Empty"/>


<li   id="WanIPv6InfoBar"            RealType="HorizonBar"         DescRef="WanIPv6Info"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
<li   id="WanDslite_checkbox"        RealType="CheckBox"           DescRef="DSLiteEnable"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="EnableDSLite"       InitValue="Empty"/>
<li   id="IPv6DSLite"                RealType="RadioButtonList"    DescRef="DSLitee8c"                    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6DSLite"         InitValue="[{TextRef:'Off',Value:'Off'},{TextRef:'Auto',Value:'Dynamic'},{TextRef:'Static',Value:'Static'}]"/>
<li   id="IPv6AFTRName"              RealType="TextBox"            DescRef="AFTRNamee8c"                  RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6AFTRName"       InitValue="Empty"   MaxLength="255"/>
<li   id="WanIPv6Address_select"     RealType="DropDownList"       DescRef="WanIpModee8cv6"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6AddressMode"    InitValue="[{TextRef:'Autoe8c',Value:'AutoConfigured'},{TextRef:'DHCPV6e8c',Value:'DHCPv6'},{TextRef:'Statice8c',Value:'Static'},{TextRef:'None',Value:'None'}]"/>
<li   id="WanPrefix_checkbox"        RealType="CheckBox"           DescRef="PrefixEnable"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="EnablePrefix"       InitValue="Empty"/>
<li   id="WanPrefix_select"            RealType="DropDownList"    DescRef="IPv6PrefixModee8c"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6PrefixMode"     InitValue="[{TextRef:'PrefixDelegation',Value:'PrefixDelegation'},{TextRef:'Static',Value:'Static'},{TextRef:'None',Value:'None'}]"/>
<li   id="WanIPv6Address_Pre_text"          RealType="TextBox"            DescRef="IPv6StaticPrefixe8c"          RemarkRef="PrefixRemark"       ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv6StaticPrefix"   InitValue="Empty"/>
<li   id="IPv6ReserveAddress"        RealType="TextBox"            DescRef="IPv6ReserveAddresse8c"        RemarkRef="IPv6ReserveAddressNote" ErrorMsgRef="Empty" Require="FALSE"   BindField="IPv6ReserveAddress" InitValue="Empty"/>
<li   id="IPv6AddressStuff"          RealType="TextBox"            DescRef="IPv6AddressStuffe8c"          RemarkRef="StuffRemark"        ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6AddressStuff"   InitValue=""TitleRef="AddressStuffTitle"/>
<li   id="WanIPv6Address_text"             RealType="TextBox"            DescRef="IPv6IPAddresse8c"             RemarkRef="IPv6AddressRemark"  ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv6IPAddress"      InitValue="Empty"/>
<li   id="IPv6AddrMaskLenE8c"           RealType="TextBox"            DescRef="IPv6AddrMaskLenE8c2"           RemarkRef="IPv6AddrMaskLenE8cRemark"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6AddrMaskLenE8c"    InitValue="Empty"/>
<li   id="WanIPv6_Gateway_text"               RealType="TextBox"            DescRef="IPv6GatewayE8c1"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6GatewayE8c"    InitValue="Empty"/>
<li   id="IPv6SubnetMask"            RealType="TextBox"            DescRef="IPv4SubnetMaske8c"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv6SubnetMask"     InitValue="Empty"/>
<li   id="IPv6DefaultGateway"        RealType="TextBox"            DescRef="IPv4DefaultGatewaye8c"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="IPv6Gateway"        InitValue="Empty"/>
<li   id="WanIPv6Pri_DNS_text"      RealType="TextBox"            DescRef="IPv6PrimaryDNSServer"      RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6PrimaryDNS"     InitValue="Empty"/>
<li   id="WanIPv6Sec_DNS_text"      RealType="TextBox"            DescRef="IPv6SecondaryDNSServer"    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6SecondaryDNS"   InitValue="Empty"/>
<li   id="IPv6WanMVlanId"            RealType="TextBox"            DescRef="WanMVlanIde8c"                RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="IPv6WanMVlanId"     InitValue="Empty"/>

<script>ParsePageControl(true);CleanServiceListVoip();</script>
<script>
function WanSelectControl()
{ 
	var Control = getElById("WanConnectName_select");
	ControlWanNewConnection();
	if(Control.value == 'New')
	{
		
		setControl(-1);	
		setDisable("ButtonDelete", 0);
		setDisable("ButtonNew", 1);
		if(Wan.length == 0)
		{
			setDisable("ButtonApply", 1);
		}
		return;
	}
	else
	{
		var SelectWan = GetSelectWan(Control.value);
		if(IsTr069WanOnlyRead() && (SelectWan.ServiceList.indexOf("TR069") >= 0))
		{
			setDisable("ButtonDelete", 1);
			setDisable("ButtonNew", 1);
		}
		else
		{
			setDisable("ButtonDelete", 0);
			setDisable("ButtonNew", 0);
		}
		
		setControl(-2);
	}
	
}
</script>
<script>
(function(){
	PromptInfo = function (id, des) {
		this.id = id;
		this.des = des;
	}
	
	var List = new Array();
	
	List[0] = new PromptInfo('LcpEchoReqCheck', 'LcpEchoReqCheckDes');
	List[1] = new PromptInfo('IPv6ReserveAddress', 'IPv6ReserveAddressDes');
	
	try{
		for ( var i in List){
			getElementById(List[i].id).setAttribute('title', Languages[List[i].des]);
		}
	}
	catch(e){

	}
})();
</script>
</table>

<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
		<td width="25%">
		</td>
        <td class="table_submit" >
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
			<input id="ButtonNewWan" class="submit" type="button"  onclick="javascript:return ClickNewWan();"/>
			<input id="ButtonNew" class="submit" type="button"  onclick="javascript:return ClickAddWan();"/>
            <input id="ButtonApply"  type="button" value="OK" onclick="javascript:return OnApply();" class="submit" />
			<input id="ButtonDelete"  type="button" value="Delete" onclick="javascript:return OnDelete();" class="submit" />
        </td>
    </tr>
</table>

<script>
ControlWanNewConnection();
setText('ButtonNewWan', Languages['Connection']);
setText('ButtonNew', Languages['New_Connection']);
setText("ButtonApply", "保存/应用");
setText("ButtonDelete","删除");
getElById('ButtonNewWan').title = "新建一条WAN口";
getElById('ButtonNew').title = "新建一条当前连接的兄弟WAN口";
</script>

<script>DisplayConfigPanel(0);</script>
</form>

</body>
</html>
