<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html  id="Page" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache" >
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
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
	.nofloat{
		float:none;
	}
	
	/*IE7 compatible begin*/
	.contentItem{
		*text-align:left;
	}
	
	.contenbox{
		*width:300px;
		*text-align:left;
		*padding-left:10px;
	}
	
	.txt_Username{
		*padding-left:10px;
	}
	
	.textboxbg{
		*margin:auto 0px;
	}
	/*IE7 compatible end*/
	
	#guideontauth{
		margin-left:-90px;
		*margin-left:0px;		/*IE7 compatible*/
	}
	#guideskip{
		text-decoration:none;
		color:#666666;
		white-space:nowrap;
		*display:block;			/*IE7 compatible*/
		*margin-top:-26px;		/*IE7 compatible*/
		*margin-left:230px;		/*IE7 compatible*/
		*text-decoration:none;	/*IE7 compatible*/
	}
	a span{
		font-size:16px;
		margin-left:10px;
	}
	.width_100px {
		width:90px;
	}
	.mainbodysmart {
		background-color:#FFFFFF;
		margin-left: 50px;
		margin-right:50px;
		margin-top: 20px;
		list-style: none;
	}
    </style>
	

</head>

<script>
var para = '';
var CfgGuide = -1;
if (window.location.href.indexOf("cfgguide") != -1)
{
	para = window.location.href.split("cfgguide")[1]; 
	CfgGuide = para.split("=")[1];
}
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';


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

function LoadFrame()
{
	if (1 == CfgGuide)
	{
		setDisplay("PromptPanel", 0);
		setDisplay("PromptPane2", 1);
		setDisplay("btnguidewan", 1);
		$("#ConfigPanel").css("background-color", "#FFFFFF");
		window.parent.adjustParentHeight();
	}
	else
	{
		setDisplay("PromptPanel", 1);
		setDisplay("PromptPane2", 0);
		setDisplay("btnguidewan", 0);
		$("#ConfigPanel").css("background-color", "#d8d8d8");
	}
	
	if("undefined" != typeof(CusLoadFrame))
	{
		CusLoadFrame();
	}
	
	ModifyWanList(ModifyWanData);
}
</script>
<script>
if (1 == CfgGuide)
{
	document.write('<body class="mainbodysmart" onLoad="LoadFrame();" >');
}
else
{
	document.write('<body class="mainbody" onLoad="LoadFrame();" >');
}
</script>
<body  id="wanbody" onLoad="LoadFrame();" >
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="javascript" src="../common/managemode.asp"></script>
<script language="javascript" src="../common/ontstate.asp"></script>
<script language="javascript" src="<%HW_WEB_CleanCache_Resource(wanlanguage.html);%>"></script>
<script language="javascript" src="../common/wanaddressacquire.asp"></script>
<script language="javascript" src="../common/wandns.asp"></script>
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="javascript" src="../common/lanmodelist.asp"></script>
<script language="javascript" src="../common/wan_pageparse.asp"></script>
<script language="javascript" src="../common/wan_servicelist.asp"></script>
<script language="javascript" src="../common/wan_control.asp"></script>
<script language="javascript" src="../common/wan_check.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/bbsp/wan/wan.cus);%>"></script>
<script language="JavaScript" type="text/javascript">
var Wan = GetWanList();
var SpecWanCfgParaList = [];
var TELMEX = false;
var IsSurportPolicyRoute  = "<% HW_WEB_GetFeatureSupport(BBSP_FT_ROUTE_POLICY);%>";
var DoubleFreqFlag = <%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DOUBLE_WLAN);%>;
var RadioWanFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_RADIO_WAN_LOAD);%>";  
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var MobileBackupWanSwitch = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Mobile_Backup.Enable);%>';

var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var WLANFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>';

function IsAdminUser()
{
    return (curUserType == sysUserType);
}

function TopoInfoClass(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
    if(WLANFlag != 1)
	  {   
        this.SSIDNum = 0;
	  } 
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

function stDevInfo(domain,HardwareVersion,ModelName)
{
	this.domain 			= domain;
	this.HardwareVersion 	= HardwareVersion;		
	this.ModelName 		    = ModelName;
}	
var devInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, HardwareVersion|ModelName, stDevInfo);%>; 
var devInfo = devInfos[0];

if (MobileBackupWanSwitch == '')
{
	MobileBackupWanSwitch = 0;
}

if (GetCfgMode().TELMEX == "1")
{
	TELMEX = true;
}
else
{
	TELMEX = false;
}
</script>
<div id="PromptPanel" style="display:none;">
<script language="JavaScript" type="text/javascript">
 if (false == TELMEX)
 {
	  if ((RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 0))
	  {

		   HWCreatePageHeadInfo("wan", GetDescFormArrayById(Languages, "bbsp_mune"), GetDescFormArrayById(Languages, "WanHeadDescription2"), false);
	  }
	  else
	  {

		  HWCreatePageHeadInfo("wan", GetDescFormArrayById(Languages, "bbsp_mune"), GetDescFormArrayById(Languages, "WanHeadDescription"), false);
	  }
 }
 else
 {
		HWCreatePageHeadInfo("wan", GetDescFormArrayById(Languages, "bbsp_mune"), GetDescFormArrayById(Languages, "WanHeadDescription_telmex"), false);
 }
 </script>
</div>
<div id="PromptPane2" style="display:none;">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<TR><TD align="middle" height="10px"></TD></TR>
</table>
</div>
<div class="title_spread"></div>

<script>
ShowWanListTable();
</script>

<script>
function DeleteLineRow()
{
   var tableRow = getElementById("wanInstTable");
   if (tableRow.rows.length > 2)
   tableRow.deleteRow(tableRow.rows.length-1);
   return false;
}

var gWanMode = 'IP_Routed';
var selctIndex2 = 0;
								
function setControl(Index)
{
	selctIndex = Index ;
	selctIndex2 = (-1 == Index) ? selctIndex2 : Index;

   setDisable("ButtonApply", "0");
   setDisable("ButtonCancel", "0");
   if (-1 == Index)
   {
        if (GetWanList().length >= 8)
        {
			DeleteLineRow();
            AlertMsg("WanIsFull");
            return false;    
        }

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
            var protoType = getElementById('ProtocolType');
            protoType.options.length = 0;
			protoType.options.add(new Option(Languages['IPv4'],'IPv4'));
			protoType.options.add(new Option(Languages['IPv6'],'IPv6'));	
			protoType.options.add(new Option(Languages['IPv4IPv6'],'IPv4/IPv6')); 
		}
		
		var UserList = new Array();
		for (i = 0;i < GetWanList().length; i++)
		{
			if ((GetCfgMode().PTVDF == "1") && (RadioWanFeature == "1") && (IsAdminUser() == false) && (MobileBackupWanSwitch == 1))
			{
				if (GetWanList()[i].RealName.indexOf("RADIO") < 0)
				{
					continue;
				}
			}
			UserList.push(GetWanList()[i]);
		}
        var CurrentWan = UserList[Index];
		gWanMode = CurrentWan.Mode;
        EditFlag = "EDIT";
        BindPageData(CurrentWan);
        ControlPage(CurrentWan);
        DisplayConfigPanel(1);
   }

	displayProtocolType();
	displayWanMode();
}

function DisplayConfigPanel(Flag)
{
	setDisplay("ConfigForm", Flag);
    setDisplay("ConfigPanelButtons", Flag);  
	if (1 == CfgGuide)
	{
		window.parent.adjustParentHeight();
	}
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
    setDisable("ButtonCancel", "1");
	
	var Parameter = {};
	FillForm(Parameter, Wan);
	Parameter.asynflag = null;
	Parameter.FormLiList = WanConfigFormList;
	Parameter.OldValueList = null;
	Parameter.SpecParaPair = SpecWanCfgParaList;
	var tokenvalue = getValue('onttoken');			
			
    var DnsUrl = (Wan.IPv6AddressMode=="Static") ? "&k=GROUP_a_y.X_HW_IPv6.IPv6DnsServer" : "";
    var IPv6Path = (Wan.IPv6Enable == "1") ? ('&m=GROUP_a_y.X_HW_IPv6.IPv6Address&n=GROUP_a_y.X_HW_IPv6.IPv6Prefix'+DnsUrl) : '';
    var DSLite = (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed") ? ('&j=GROUP_a_y.X_HW_IPv6.DSLite') : '';
    var Path6Rd = (true == Is6RdSupported()) ? ('&r=GROUP_a_y.X_HW_6RDTunnel') : '';
	
    var Url = 'addcfg.cgi?' + GetAddWanUrl(Wan) + IPv6Path + DSLite + Path6Rd +'&RequestFile=html/bbsp/wan/confirmwancfginfo.html';

	if (1 == CfgGuide)
	{
		Url += '&cfgguide=1';
	}
	
	HWSetAction(null, Url, Parameter, tokenvalue);
}

function addParamForRadioWan(Wan)
{
	var AddPara1 = new stSpecParaArray("s.Enable", Wan.RadioWanPSEnable, 1);
	SpecWanCfgParaList.push(AddPara1);
	var AddPara2 = new stSpecParaArray("d.RadioWanPSEnable", '', 2);
	SpecWanCfgParaList.push(AddPara2);
	
	var AddPara3 = new stSpecParaArray("s.PingIP", Wan.PingIPAddress, 1);
	SpecWanCfgParaList.push(AddPara3);
	var AddPara4 = new stSpecParaArray("d.PingIPAddress", '', 2);
	SpecWanCfgParaList.push(AddPara4);
	
	var AddPara5 = new stSpecParaArray("t.Username", Wan.RadioWanUsername, 1);
	SpecWanCfgParaList.push(AddPara5);
	var AddPara6 = new stSpecParaArray("d.RadioWanUsername", '', 2);
	SpecWanCfgParaList.push(AddPara6);
	
	var AddPara7 = new stSpecParaArray("t.Password", Wan.RadioWanPassword, 1);
	if(Wan.RadioWanPassword != radio_hidepassword)
	{
		SpecWanCfgParaList.push(AddPara7);
	}
	var AddPara8 = new stSpecParaArray("d.RadioWanPassword", '', 2);
	SpecWanCfgParaList.push(AddPara8);
	
	var AddPara9 = new stSpecParaArray("d.AccessType", '', 2);
	SpecWanCfgParaList.push(AddPara9);

    var AddPara10 = new stSpecParaArray("t.ServiceType", Wan.ServiceList, 1);
	SpecWanCfgParaList.push(AddPara10);
    
}


function OnRadioWanApply()
{
	var Wan = GetPageData();
	var Url = '';
	var RadioWanPSPath = '';
	var RadioWanPath = '';

	if (CheckRadioWan(Wan, EditFlag) == false)
	{
		return false;
	} 
	
	
	setDisable("ButtonApply", "1");
    setDisable("ButtonCancel", "1");
    
    var Parameter = {};
	addParamForRadioWan(Wan);
	
	Parameter.asynflag = null;
	Parameter.FormLiList = WanConfigFormList;
	Parameter.OldValueList = null;
	Parameter.SpecParaPair = SpecWanCfgParaList;
	
	if (EditFlag == "ADD")
	{
		RadioWanPSPath = '&s=InternetGatewayDevice.X_HW_RadioWanPS';
		RadioWanPath = '&t=InternetGatewayDevice.X_HW_Radio_WAN';
		Url = 'addcfg.cgi?' + RadioWanPath + RadioWanPSPath + '&RequestFile=html/bbsp/wan/confirmwancfginfo.html';
	}
	else
	{
		RadioWanPSPath = '&s=InternetGatewayDevice.X_HW_RadioWanPS.1';
		RadioWanPath = '&t=InternetGatewayDevice.X_HW_Radio_WAN.1';
		Url = 'complex.cgi?' + RadioWanPath + RadioWanPSPath + '&RequestFile=html/bbsp/wan/confirmwancfginfo.html';  
	}
	
	if (1 == CfgGuide)
	{
		Url += '&cfgguide=1';
	}
	
	if (Wan.RadioWanPSEnable == 1)
	{
		if ((devInfo.ModelName.toString().toUpperCase() == 'HG8247H') 
		 && (devInfo.HardwareVersion.toString().toUpperCase().indexOf(".A") >= 0))
		{
			AlertEx(Languages['WlWanWifiConflictAlert']);
		}
	}
	
	var tokenvalue = getValue('onttoken');
	var bRet = HWSetAction(null, Url, Parameter, tokenvalue);
	if(!bRet)
	{
		setDisable("ButtonApply", "0");
		setDisable("ButtonCancel", "0"); 
	}
	
}

function addParamForBroWan(wan)
{
	var AddPara1 = new stSpecParaArray("u.X_HW_VLAN", wan.VlanId, 1);
	SpecWanCfgParaList.push(AddPara1);
	
	var AddPara2 = new stSpecParaArray("u.X_HW_PriPolicy", wan.PriorityPolicy, 1);
	SpecWanCfgParaList.push(AddPara2);
	
	var AddPara3 = new stSpecParaArray("u.X_HW_PRI", wan.Priority, 1);
	SpecWanCfgParaList.push(AddPara3);
	
	var AddPara4 = new stSpecParaArray("u.X_HW_DefaultPri", wan.DefaultPriority, 1);
	SpecWanCfgParaList.push(AddPara4);
}

function OnEditApply()
{
    var Wan = GetPageData();	
	
	selctIndex = (-1 == selctIndex) ? selctIndex2 : selctIndex;
	
	var CurrentWan = GetWanList()[selctIndex];

	if (true == IsCurrentRadioWan())
	{
		if (CheckRadioWan(Wan, EditFlag) == false)
		{
			return false;
		}
	}
	else
	{
		if (CheckWan(Wan) == false)
		{
			return false;
		}
	}

	if (CheckWanSet(Wan) == false)
	{
		return false;
	}
	
	if (isE8cAndCMCC())
	{
		if (gWanMode != Wan.Mode && Wan.Mode == 'IP_Routed')
		{	
			Wan.IPv4NATEnable = 1;
		}
	}
    
    setDisable("ButtonApply", "1");
    setDisable("ButtonCancel", "1");    
    
	var Parameter = {};
	FillForm(Parameter, Wan);
    
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


	var CurrentWan = GetWanList()[selctIndex];
	var broWan = GetBrotherWan(CurrentWan);
	var FlagForAddBroWan = false;
	
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
        
        var Url = 'complex.cgi?'
            + 'y=' + Wan.domain
            + IPv6PrefixUrl
            + IPv6addressUrl
            + DnsUrl
            + '&j=' + Wan.domain + DSLite
            + '&r=' + Wan.domain + Path6Rd
            + '&u=' + broWan.domain
            + '&RequestFile=html/bbsp/wan/confirmwancfginfo.html';   			

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
            + '&RequestFile=html/bbsp/wan/confirmwancfginfo.html'; 
	}

	if (FlagForAddBroWan == true)
	{
	    addParamForBroWan(broWan);
	}
	
	Parameter.asynflag = null;
	Parameter.FormLiList = WanConfigFormList;
	Parameter.OldValueList = CurrentWan;
	Parameter.SpecParaPair = SpecWanCfgParaList;
	
	if (1 == CfgGuide)
	{
		Url += '&cfgguide=1';
	}
	
	var tokenvalue = getValue('onttoken');
	var bRet = HWSetAction(null, Url, Parameter, tokenvalue);
	if(!bRet)
	{
		setDisable("ButtonApply", "0");
		setDisable("ButtonCancel", "0"); 
	}
}

function OnEditApplyOmitBrother()
{
    var Wan = GetPageData();	
	
    selctIndex = (-1 == selctIndex) ? selctIndex2 : selctIndex;
	
    var CurrentWan = GetWanList()[selctIndex];
	
    if (CheckWan(Wan) == false)
    {
        return false;
    }
	
    if (CheckWanSet(Wan) == false)
    {
        return false;
    }
	
    if (isE8cAndCMCC())
    {
        if (gWanMode != Wan.Mode && Wan.Mode == 'IP_Routed')
        {	
            Wan.IPv4NATEnable = 1;
        }
    }
    
    setDisable("ButtonApply", "1");
    setDisable("ButtonCancel", "1");    
    
	var Parameter = {};
	FillForm(Parameter, Wan);
	Parameter.asynflag = null;
	Parameter.FormLiList = WanConfigFormList;
	Parameter.OldValueList = CurrentWan;
	Parameter.SpecParaPair = SpecWanCfgParaList;
    
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
 
    var DSLite = (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed") ? ('.X_HW_IPv6.DSLite') : '';
    var Url = 'complex.cgi?'
            + 'y=' + Wan.domain
            + IPv6PrefixUrl
            + IPv6addressUrl
            + DnsUrl
            + '&j=' + Wan.domain + DSLite
            + '&RequestFile=html/bbsp/wan/confirmwancfginfo.html'; 
	
	if (1 == CfgGuide)
	{
		Url += '&cfgguide=1';
	}
	
	var tokenvalue = getValue('onttoken');
	var bRet = HWSetAction(null, Url, Parameter, tokenvalue);
	if(!bRet)
	{
		setDisable("ButtonApply", "0");
		setDisable("ButtonCancel", "0"); 
	}
}

function OnApply()
{   
	if (true == IsCurrentRadioWan())
	{
		OnRadioWanApply();
		return;
	}
	
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
function OnCancel()
{
    DisplayConfigPanel(0);
    if (EditFlag == "ADD")
    {
         DeleteLineRow();
         return false;
    }
}

function getWanindexByDomain(wandomain)
{
	var wanindex = -1;
	for (var i = 0;i < Wan.length; i++)
	{
		if (wandomain == Wan[i].domain)
		{
			wanindex = i;
			return wanindex;
		}
	}
	return wanindex;
}

function clickRemove() 
{
    var CheckBoxList = document.getElementsByName("wanInstTablerml");
    var Count = 0;
    var i;
	var Wan = GetPageData();
    for (i = 0; i < CheckBoxList.length; i++)
    {
        if (CheckBoxList[i].checked == true)
        {
            Count++;
        }
    }
    
    if (Count == 0)
    {
        return false;
    }
    
    setDisable("DeleteButton","1");
    setDisable("ButtonApply", "1");
    setDisable("ButtonCancel", "1");   

	if(!DoubleFreqFlag)
	{
		var Form = new webSubmitForm();
		for (i = 0; i < CheckBoxList.length; i++)
		{
			if (CheckBoxList[i].checked != true)
			{
				continue;
			}
			
			var wanindex = getWanindexByDomain(CheckBoxList[i].value);

			if ((-1 != wanindex) && (true == IsRadioWanSupported(GetWanList()[wanindex])))
			{
				Form.addParameter('InternetGatewayDevice.X_HW_RadioWanPS.1','');
				Form.addParameter('InternetGatewayDevice.X_HW_Radio_WAN.1','');
				continue;
			}
			Form.addParameter(CheckBoxList[i].value,'');
	
		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		if (1 == CfgGuide)
		{
			Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wan.asp'+'&cfgguide=1');
		}
		else
		{
			Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wan.asp');
		}
    }
	else
	{	
		var LanWanBindInfo = GetLanWanBindInfo(domainTowanname(Wan.domain));

		var Form = new webSubmitForm();
		for (i = 0; i < CheckBoxList.length; i++)
		{
			if (CheckBoxList[i].checked != true)
			{
				continue;
			}
			
			var wanindex = getWanindexByDomain(CheckBoxList[i].value);
			if ((-1 != wanindex) && (true == IsRadioWanSupported(GetWanList()[wanindex])))
			{
				Form.addParameter('InternetGatewayDevice.X_HW_RadioWanPS.1','');
				Form.addParameter('InternetGatewayDevice.X_HW_Radio_WAN.1','');
				continue;
			}

			Form.addParameter(CheckBoxList[i].value,'');
		}
		if(LanWanBindInfo != null)
		{

		}
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		if (1 == CfgGuide)
		{
			Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wan.asp'+'&cfgguide=1');
		}
		else
		{
			Form.setAction('del.cgi?RequestFile=html/bbsp/wan/wan.asp');
		}
	}
	Form.submit();
}

function FillUserForm(Parameter, Wan)
{	
    var UserPwdFlag = 2;
	var IPv4DialModeFlag = 2;
	var IdleDisconnectFlag = 2;
	var NatTypeFlag = 2;
	var NATEnabledFlag = 2;
	
	if (Wan.Mode == 'IP_Routed')
    {
        switch (Wan.IPv4AddressMode)
        {
            case 'PPPoE':
				UserPwdFlag = 1;
                if (GetCfgMode().BJUNICOM == "1")
                {
					IPv4DialModeFlag = 1;
                    if (Wan.IPv4DialMode == "OnDemand")
                    {
						IdleDisconnectFlag = 1;
                    }                    
                }
                break;
        }
    }
	if (Wan.Mode == 'IP_Routed' && Wan.IPv4Enable == "1")
	{
		if(IsSonetUser() && Wan.IPv4NATEnable == "1")
		{
			NatTypeFlag = 1;
		}
	}
	if(GetCfgMode().BJCU == "1" )
    {
		NATEnabledFlag = 1;
    }

    SpecWanCfgParaList = new Array(new stSpecParaArray('d.domain','', 2),
									new stSpecParaArray('d.AccessType','', 2),
									new stSpecParaArray('d.EncapMode','', 2),
									new stSpecParaArray('d.ProtocolType','', 2),
									new stSpecParaArray('d.Mode','', 2),
									new stSpecParaArray('d.EnableVlan','', 2),
									new stSpecParaArray('d.VlanId','', 2),
									new stSpecParaArray('d.ServiceList','', 2),
									new stSpecParaArray('d.PriorityPolicy','', 2),
									new stSpecParaArray('d.DefaultPriority','', 2),
									new stSpecParaArray('d.Priority','', 2),
									new stSpecParaArray('d.IPv4MXU','', 2),
									new stSpecParaArray('d.UserName','', 2),
									new stSpecParaArray('d.LcpEchoReqCheck','', 2),
									new stSpecParaArray('d.IPv4BindLanList', '', 2),
									new stSpecParaArray('d.DstIPForwardingList', '', 2),
									new stSpecParaArray('d.IPv4AddressMode', '', 2),
									new stSpecParaArray('d.IPv4NATEnable', '', 2),
									new stSpecParaArray('d.NatType', '', 2),
									new stSpecParaArray('d.IPv4VendorId', '', 2),
									new stSpecParaArray('d.IPv4ClientId', '', 2),
									new stSpecParaArray('d.IPv4IPAddress', '', 2),
									new stSpecParaArray('d.IPv4SubnetMask', '', 2),
									new stSpecParaArray('d.IPv4Gateway', '', 2),
									new stSpecParaArray('d.IPv4PrimaryDNS','', 2),
									new stSpecParaArray('d.IPv4SecondaryDNS','', 2),
									new stSpecParaArray('d.IPv4DialMode', '', 2),
									new stSpecParaArray('d.IPv4DialIdleTime', '', 2),
									new stSpecParaArray('d.IPv4IdleDisconnectMode', '', 2),
									new stSpecParaArray('d.IPv4WanMVlanId','', 2),
									new stSpecParaArray('d.EnableLanDhcp','', 2),
									new stSpecParaArray('d.PingIPAddress','', 2),
									new stSpecParaArray('d.IPv6PrefixMode','', 2),
									new stSpecParaArray('d.IPv6StaticPrefix','', 2),
									new stSpecParaArray('d.IPv6AddressMode','', 2),
									new stSpecParaArray('d.IPv6ReserveAddress','', 2),
									new stSpecParaArray('d.IPv6AddressStuff','', 2),
									new stSpecParaArray('d.IPv6IPAddress','', 2),
									new stSpecParaArray('d.IPv6AddrMaskLenE8c','', 2),
									new stSpecParaArray('d.IPv6GatewayE8c','', 2),
									new stSpecParaArray('d.IPv6SubnetMask','', 2),
									new stSpecParaArray('d.IPv6Gateway','', 2),
									new stSpecParaArray('d.IPv6PrimaryDNS','', 2),
									new stSpecParaArray('d.IPv6SecondaryDNS','', 2),
									new stSpecParaArray('d.IPv6WanMVlanId','', 2),
									new stSpecParaArray('d.IPv6DSLite','', 2),
									new stSpecParaArray('d.IPv6AFTRName','', 2),
									
									new stSpecParaArray('y.Username',Wan.UserName, UserPwdFlag),
									new stSpecParaArray('y.Password',Wan.Password, UserPwdFlag),
									new stSpecParaArray('y.ConnectionTrigger',Wan.IPv4DialMode, IPv4DialModeFlag),
									new stSpecParaArray('y.IdleDisconnectTime',Wan.IPv4DialIdleTime, IdleDisconnectFlag),
									new stSpecParaArray('y.X_HW_NatType',Wan.NatType, NatTypeFlag),
									new stSpecParaArray('y.ConnectionType',Wan.Mode, NATEnabledFlag),
									new stSpecParaArray('y.NATEnabled',Wan.IPv4NATEnable, NATEnabledFlag)			   
									 );
									 
}

function FillSysForm(Parameter, Wan)
{
	var IPv6WanMVlanId = (Wan.IPv6WanMVlanId == "") ? -1 : Wan.IPv6WanMVlanId;
	var ServiceList = (true == IsOldServerListType(Wan.ServiceList)) ? Wan.ServiceList : 'INTERNET';
	var ExServiceList = (true == IsOldServerListType(Wan.ServiceList)) ? '' : Wan.ServiceList ;
	var VlanId = (Wan.EnableVlan == "1") ? Wan.VlanId : "0";
	var PriorityPolicy = (Wan.EnableVlan == "1") ? Wan.PriorityPolicy:"Specified";
	var EnableLanDhcpFlag = 2;
	
	if ( Wan.ServiceList.match('INTERNET') || Wan.ServiceList.match('IPTV') || Wan.ServiceList.match('OTHER') )
    {
        if(isE8cAndCMCC())
        {
		   EnableLanDhcpFlag = 1;
	    }		
    }
	
    var DstIPForwardingListFlag = 2; 
    if ( true == IsDstIPForwardingListVisibility(Wan,Wan.ServiceList) )
    {
		DstIPForwardingListFlag = 1;
    }
	
	var IPv4WanMVlanId = ("" == Wan.IPv4WanMVlanId) ? 0xFFFFFFFF : Wan.IPv4WanMVlanId;
	
	var IPv4NATEnableFlag = 2;
	var NatTypeFlag = 2;
	if (Wan.Mode == 'IP_Routed')
    {
		if ('PTVDF' == CfgModeWord.toUpperCase()) 
		{
			if(!(Wan.ServiceList=="TR069"))
			{
				IPv4NATEnableFlag = 1;
			}
		}
		else
		{
			IPv4NATEnableFlag = 1;
		}

        if ((Wan.IPv4NATEnable == "1") 
			&&("1" != GetCfgMode().TELMEX)
		    &&("1" != GetCfgMode().PCCWHK)
		    &&("1" != GetCfgMode().MOBILY)
		    &&("1" != GetRunningMode()))
        {
         	NatTypeFlag = 1;      
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
	
	var  UsernameFlag = 2;
	var  PasswordFlag = 2;
	var  LcpEchoReqCheckFlag = 2;
	var  IPv4DialModeFlag = 2;
	var  IPv4DialIdleTimeFlag = 2;
	var  IPv4IdleDisconnectModeFlag = 2;
	var  DNSEnabledFlag = 2;
	var  MXUSize = (Wan.IPv4MXU == "") ?((Wan.IPv4AddressMode == 'PPPoE') ? 1492 : 1500) : Wan.IPv4MXU;
	var  MRUFlag = 2;
	var  MTUFlag = 2;
	var  AddressingTypeFlag = 2;
	var	 IPv4IPAddressFlag = 2;
	var	 IPv4SubnetMaskFlag = 2;
	var	 IPv4GatewayFlag = 2;
	var	  DnsStrFlag = 2;
	var	 IPv4VendorIdFlag = 2;
	var	 IPv4ClientIdFlag = 2;
	if (Wan.Mode == 'IP_Routed')
	{	
        switch (Wan.IPv4AddressMode)
        {
            case 'PPPoE':
				UsernameFlag = 1;
				PasswordFlag = 1;
                if(!isE8cAndCMCC())
                {
					LcpEchoReqCheckFlag = 1;
                }
                if (Wan.ServiceList == 'INTERNET' && "1" == Wan.IPv4Enable)
                {
					var IPv4DialModeFlag = 1;
                    if (Wan.IPv4DialMode == "OnDemand")
                    {
						IPv4DialIdleTimeFlag = 1;
						IPv4IdleDisconnectModeFlag = 1;
                    }
                }
				DNSEnabledFlag = 1;
				
				if("1" != GetCfgMode().PCCWHK)
				{
					MRUFlag = 1;
				}
                break;
    					
            case 'Static':
                if("1" == Wan.IPv4Enable)
                {
                    AddressingTypeFlag = 1;
					IPv4IPAddressFlag = 1;
					IPv4SubnetMaskFlag = 1;
					IPv4GatewayFlag = 1;
					DnsStrFlag = 1;
					DNSEnabledFlag = 1;

                }
				if("1" != GetCfgMode().PCCWHK)
				{
					MTUFlag = 1;
				}
                break;
                
            case 'DHCP':
                if("1" == Wan.IPv4Enable)
                {
					AddressingTypeFlag = 1;
					IPv4VendorIdFlag = 1;
					DNSEnabledFlag = 1;
					
                    if(!isE8cAndCMCC())
                    {
						IPv4ClientIdFlag = 1;
                    }
                }
				if("1" != GetCfgMode().PCCWHK)
				{
					MTUFlag = 1;
				}
                break;
            default:		
                break;
        }
    }

	var BindListFlag = 2;
	if ( Wan.ServiceList.match('INTERNET')
	|| Wan.ServiceList.match('IPTV')
	|| Wan.ServiceList.match('OTHER') )
    {   
        BindListFlag = 1;
		var Bindlist = "";
        var Bindlist2 = "";
        for (var i = 1; i <= TopoInfo.EthNum; i++)
        {                     
            if(IsLanBind("Lan"+i, Wan.IPv4BindLanList)==true)
            {
                 Bindlist = Bindlist + "Lan"  + i + ",";
            }
        }

        for (var i = 1; i <= TopoInfo.SSIDNum; i++)
        {            
            if(IsLanBind("SSID"+i, Wan.IPv4BindLanList)==true)
            {
                Bindlist = Bindlist + "SSID"  + i + ",";  
            }
        }
        Bindlist2 = Bindlist.substring(0, Bindlist.length - 1);
    }
	
	var nodePrefix = "";
	var IPv6Addr_Pre = "";
	var IPv6Pref_Pre = "";
	
	if(EditFlag == "ADD")
	{
		nodePrefix = "GROUP_a_y."; 
	}
	else if(EditFlag == "EDIT")
	{
		nodePrefix = "y.";  
	}
	
	var IPv6AddrFlag = 2;
	var IPv6ReserveAddrFlag = 2;
	if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable)
    {   		    
		
		IPv6AddrFlag = 1;
		var IPv6AddressUrl = GetIPv6AddressAcquireInfo(Wan.domain);
		if(IPv6AddressUrl==null && EditFlag == "EDIT")
		{
			IPv6Addr_Pre = 	COMPLEX_CGI_PREFIX + 'm.';	
		}
		else  
		{
			IPv6Addr_Pre = 'm.';
		}
		
		Wan.IPv6AddrMaskLenE8c = (Wan.IPv6AddrMaskLenE8c == "") ? "0" : Wan.IPv6AddrMaskLenE8c;
		if ((Wan.EncapMode.toString().toUpperCase() == "IPOE") && (Wan.IPv6AddressMode == "None") && (Wan.IPv6ReserveAddress != ""))
		{
			if(!isE8cAndCMCC())
			{
				IPv6ReserveAddrFlag = 1;
			}
		}
    }
	
	var IPv6PrefFlag = 2;
	if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable)
    { 		
		IPv6PrefFlag = 1;
		var IPv6PrefixUrl = GetIPv6PrefixAcquireInfo(Wan.domain);
		if(IPv6PrefixUrl==null && EditFlag == "EDIT")
		{                   
			IPv6Pref_Pre =	COMPLEX_CGI_PREFIX + 'n.';	
		}
		else
		{
			IPv6Pref_Pre = 'n.';
		}
    }
	
	var IPv6DnsFlag = 2;
	var IPv6DnsInterfaceFlag = 2;
	var IPv6Dns_Pre = "";
	if ("IP_Routed" == Wan.Mode  && "1" == Wan.IPv6Enable && Wan.IPv6AddressMode == "Static")
    { 		
		IPv6DnsFlag = 1;
		var DnsUrl = GetIPv6WanDnsServerInfo(domainTowanname(Wan.domain));
		var DnsServer = GetWanDnsServerString(Wan.IPv6PrimaryDNS, Wan.IPv6SecondaryDNS);
		if(DnsUrl==null && EditFlag == "EDIT")
		{
			IPv6DnsInterfaceFlag = 1;
			IPv6Dns_Pre = COMPLEX_CGI_PREFIX+'k.';		
		}
		else
		{
			IPv6Dns_Pre = 'k.';				
		}
    }
	
	var IPv6DSLiteFlag = 2;
	if (Wan.ProtocolType.toString() == "IPv6" && Wan.Mode == "IP_Routed" )
	{
		IPv6DSLiteFlag = 1;
	}
	
	var RdEnable = ('Off' == Wan.RdMode) ? '0' : '1';
	var RdFlag = 2;
	var RdModeFlag = 2;
	if ( Wan.ProtocolType.toString() == "IPv4" && Wan.Mode == "IP_Routed" && true == Is6RdSupported())
	{
	    RdFlag = 1;

		if ('Off' == Wan.RdMode)
		{
		}
		else if('Dynamic' == Wan.RdMode)
		{
			RdModeFlag = 1;
		}
		else
		{
			if (Wan.EncapMode.toString().toUpperCase() != "PPPOE")
			{
				RdModeFlag = 1;
			}
		}
    }

    if(Wan.Mode == 'IP_Bridged')
    {
		Wan.IPv4IPAddress ='0.0.0.0';
        Wan.IPv4SubnetMask='0.0.0.0';
        Wan.IPv4Gateway   ='0.0.0.0';
        IPv4IPAddressFlag = 1;
		IPv4SubnetMaskFlag = 1;
		IPv4GatewayFlag = 1;
    }
	
    SpecWanCfgParaList = new Array(new stSpecParaArray('d.domain','', 2),
									new stSpecParaArray('d.AccessType','', 2),
									new stSpecParaArray('d.EncapMode','', 2),
									new stSpecParaArray('d.ProtocolType','', 2),
									new stSpecParaArray('d.Mode','', 2),
									new stSpecParaArray('d.EnableVlan','', 2),
									new stSpecParaArray('d.VlanId','', 2),
									new stSpecParaArray('d.ServiceList','', 2),
									new stSpecParaArray('d.PriorityPolicy','', 2),
									new stSpecParaArray('d.DefaultPriority','', 2),
									new stSpecParaArray('d.Priority','', 2),
									new stSpecParaArray('d.IPv4MXU','', 2),
									new stSpecParaArray('d.UserName','', 2),
									new stSpecParaArray('d.LcpEchoReqCheck','', 2),
									new stSpecParaArray('d.IPv4BindLanList', '', 2),
									new stSpecParaArray('d.DstIPForwardingList', '', 2),
									new stSpecParaArray('d.IPv4AddressMode', '', 2),
									new stSpecParaArray('d.IPv4NATEnable', '', 2),
									new stSpecParaArray('d.NatType', '', 2),
									new stSpecParaArray('d.IPv4VendorId', '', 2),
									new stSpecParaArray('d.IPv4ClientId', '', 2),
									new stSpecParaArray('d.IPv4IPAddress', '', 2),
									new stSpecParaArray('d.IPv4SubnetMask', '', 2),
									new stSpecParaArray('d.IPv4Gateway', '', 2),
									new stSpecParaArray('d.IPv4PrimaryDNS','', 2),
									new stSpecParaArray('d.IPv4SecondaryDNS','', 2),
									new stSpecParaArray('d.IPv4DialMode', '', 2),
									new stSpecParaArray('d.IPv4DialIdleTime', '', 2),
									new stSpecParaArray('d.IPv4IdleDisconnectMode', '', 2),
									new stSpecParaArray('d.IPv4WanMVlanId','', 2),
									new stSpecParaArray('d.EnableLanDhcp','', 2),
									new stSpecParaArray('d.PingIPAddress','', 2),
									new stSpecParaArray('d.IPv6PrefixMode','', 2),
									new stSpecParaArray('d.IPv6StaticPrefix','', 2),
									new stSpecParaArray('d.IPv6AddressMode','', 2),
									new stSpecParaArray('d.IPv6ReserveAddress','', 2),
									new stSpecParaArray('d.IPv6AddressStuff','', 2),
									new stSpecParaArray('d.IPv6IPAddress','', 2),
									new stSpecParaArray('d.IPv6AddrMaskLenE8c','', 2),
									new stSpecParaArray('d.IPv6GatewayE8c','', 2),
									new stSpecParaArray('d.IPv6SubnetMask','', 2),
									new stSpecParaArray('d.IPv6Gateway','', 2),
									new stSpecParaArray('d.IPv6PrimaryDNS','', 2),
									new stSpecParaArray('d.IPv6SecondaryDNS','', 2),
									new stSpecParaArray('d.IPv6WanMVlanId','', 2),
									new stSpecParaArray('d.IPv6DSLite','', 2),
									new stSpecParaArray('d.IPv6AFTRName','', 2),
									
								   new stSpecParaArray(nodePrefix+'Enable',Wan.Enable, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_IPv4Enable',Wan.IPv4Enable, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_IPv6Enable',Wan.IPv6Enable, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_IPv6MultiCastVLAN',IPv6WanMVlanId, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_SERVICELIST',ServiceList, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_ExServiceList',ExServiceList, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_VLAN',VlanId, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_PRI',Wan.Priority, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_PriPolicy',PriorityPolicy, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_DefaultPri',Wan.DefaultPriority, 1),
								   new stSpecParaArray(nodePrefix+'ConnectionType',Wan.Mode, 1),
								   new stSpecParaArray(nodePrefix+'X_HW_LanDhcpEnable',Wan.EnableLanDhcp, EnableLanDhcpFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_IPForwardList',Wan.DstIPForwardingList, DstIPForwardingListFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_MultiCastVLAN',IPv4WanMVlanId, 1),
								   new stSpecParaArray(nodePrefix+'NATEnabled',Wan.IPv4NATEnable, IPv4NATEnableFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_NatType',Wan.NatType, NatTypeFlag),
								   
								   new stSpecParaArray(nodePrefix+'Username',Wan.UserName, UsernameFlag),
								   new stSpecParaArray(nodePrefix+'Password',Wan.Password, PasswordFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_LcpEchoReqCheck',Wan.LcpEchoReqCheck, LcpEchoReqCheckFlag),
								   new stSpecParaArray(nodePrefix+'ConnectionTrigger',Wan.IPv4DialMode, IPv4DialModeFlag),
								   new stSpecParaArray(nodePrefix+'IdleDisconnectTime',Wan.IPv4DialIdleTime, IPv4DialIdleTimeFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_IdleDetectMode',Wan.IPv4IdleDisconnectMode, IPv4IdleDisconnectModeFlag),
								   new stSpecParaArray(nodePrefix+'DNSEnabled','1', DNSEnabledFlag),
								   new stSpecParaArray(nodePrefix+'MaxMRUSize',MXUSize, MRUFlag),
								   new stSpecParaArray(nodePrefix+'MaxMTUSize',MXUSize, MTUFlag),
								   new stSpecParaArray(nodePrefix+'AddressingType',Wan.IPv4AddressMode, AddressingTypeFlag),
								   new stSpecParaArray(nodePrefix+'ExternalIPAddress',Wan.IPv4IPAddress, IPv4IPAddressFlag),
								   new stSpecParaArray(nodePrefix+'SubnetMask',Wan.IPv4SubnetMask, IPv4SubnetMaskFlag),
								   new stSpecParaArray(nodePrefix+'DefaultGateway',Wan.IPv4Gateway, IPv4GatewayFlag),
								   new stSpecParaArray(nodePrefix+'DNSServers',DnsStr, DnsStrFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_VenderClassID',Wan.IPv4VendorId, IPv4VendorIdFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_ClientID',Wan.IPv4ClientId, IPv4ClientIdFlag),
								   new stSpecParaArray(nodePrefix+'X_HW_BindPhyPortInfo',Bindlist2, BindListFlag),
								   
								   new stSpecParaArray(IPv6Addr_Pre+'Alias','', IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'Origin',Wan.IPv6AddressMode, IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'IPAddress',Wan.IPv6IPAddress, IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'ChildPrefixBits',Wan.IPv6AddressStuff, IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'AddrMaskLen',Wan.IPv6AddrMaskLenE8c, IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'DefaultGateway',Wan.IPv6GatewayE8c, IPv6AddrFlag),
								   new stSpecParaArray(IPv6Addr_Pre+'UnnumberredWanReserveAddress',Wan.IPv6ReserveAddress, IPv6ReserveAddrFlag),
								   
								   new stSpecParaArray(IPv6Pref_Pre+'Alias','', IPv6PrefFlag),
								   new stSpecParaArray(IPv6Pref_Pre+'Origin',Wan.IPv6PrefixMode, IPv6PrefFlag),
								   new stSpecParaArray(IPv6Pref_Pre+'Prefix',Wan.IPv6StaticPrefix, IPv6PrefFlag),
								   
								   new stSpecParaArray(IPv6Dns_Pre+'DNSServer',DnsServer, IPv6DnsFlag),
								   new stSpecParaArray(IPv6Dns_Pre+'Interface',domainTowanname(Wan.domain), IPv6DnsInterfaceFlag),
								   
								   new stSpecParaArray("j.WorkMode",Wan.IPv6DSLite, IPv6DSLiteFlag),
								   new stSpecParaArray("j.AFTRName",Wan.IPv6AFTRName, IPv6DSLiteFlag),
								   
								   new stSpecParaArray("r.Enable",RdEnable, RdFlag),
								   new stSpecParaArray("r.RdMode",Wan.RdMode, RdModeFlag)						   
								   );
	
}

function FillForm(Parameter, Wan)  
{
    if (IsAdminUser() && 'TELECOM' != CfgModeWord.toUpperCase())
	{
        FillSysForm(Parameter, Wan);
	}
    else
	{
        FillUserForm(Parameter, Wan);
	}
}

</script>
<form id="ConfigForm">
<div class="list_table_spread"></div>
<table id="ConfigPanel"  width="100%" cellspacing="1" cellpadding="0"> 
<li   id="BasicInfoBar"              RealType="HorizonBar"         DescRef="WanBasicInfo"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
<li   id="WanDomain"                 RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.domain"             InitValue="Empty"/>
<li   id="WanSwitch"                 RealType="CheckBox"           DescRef="EnableWanConnection"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.Enable"             InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="RadioWanPSEnable"          RealType="CheckBox"           DescRef="EnableWanConnection"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.RadioWanPSEnable"   InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="AccessType"                RealType="DropDownList"       DescRef="AccessType"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.AccessType"         InitValue="[{TextRef:'Wireless',Value:'0'},{TextRef:'PON',Value:'1'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="EncapMode"                 RealType="RadioButtonList"    DescRef="EncapMode"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.EncapMode"          InitValue="[{TextRef:'IPoE',Value:'IPoE'},{TextRef:'PPPoE',Value:'PPPoE'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="ProtocolType"              RealType="DropDownList"       DescRef="WanProtocolType"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.ProtocolType"       InitValue="[{TextRef:'IPv4',Value:'IPv4'},{TextRef:'IPv6',Value:'IPv6'},{TextRef:'IPv4IPv6',Value:'IPv4/IPv6'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="WanMode"                   RealType="DropDownList"       DescRef="WanMode"                   RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.Mode"               InitValue="[{TextRef:'IP_Routed',Value:'IP_Routed'},{TextRef:'IP_Bridged',Value:'IP_Bridged'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="ServiceList"               RealType="DropDownList"       DescRef="WanServiceList"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.ServiceList"        InitValue="[{TextRef:'TR069',Value:'TR069'},{TextRef:'INTERNET',Value:'INTERNET'},{TextRef:'TR069_INTERNET',Value:'TR069_INTERNET'},{TextRef:'VOIP',Value:'VOIP'},{TextRef:'TR069_VOIP',Value:'TR069_VOIP'},{TextRef:'VOIP_INTERNET',Value:'VOIP_INTERNET'},{TextRef:'TR069_VOIP_INTERNET',Value:'TR069_VOIP_INTERNET'},{TextRef:'IPTV',Value:'IPTV'},{TextRef:'OTHER',Value:'OTHER'}, {TextRef:'VOIP_IPTV',Value:'VOIP_IPTV'}, {TextRef:'TR069_IPTV',Value:'TR069_IPTV'},{TextRef:'TR069_VOIP_IPTV',Value:'TR069_VOIP_IPTV'},{TextRef:'IPTV_INTERNET',Value:'IPTV_INTERNET'},{TextRef:'VOIP_IPTV_INTERNET',Value:'VOIP_IPTV_INTERNET'},{TextRef:'TR069_IPTV_INTERNET',Value:'TR069_IPTV_INTERNET'},{TextRef:'TR069_VOIP_IPTV_INTERNET',Value:'TR069_VOIP_IPTV_INTERNET'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="VlanSwitch"                RealType="CheckBox"           DescRef="EnableVlan"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.EnableVlan"         InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="VlanId"                    RealType="TextBox"            DescRef="VlanId"                    RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.VlanId"             InitValue="Empty"/>

<li   id="PriorityPolicy"            RealType="RadioButtonList"    DescRef="PriorityPolicy"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.PriorityPolicy"     InitValue="[{TextRef:'Specified',Value:'Specified'},{TextRef:'CopyFromIPPrecedence',Value:'CopyFromIPPrecedence'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="DefaultVlanPriority"       RealType="DropDownList"       DescRef="DefaultVlanPriority"       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.DefaultPriority"    InitValue="[{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]" ClickFuncApp="onchange=OnChangeUI"/>

<li   id="VlanPriority"              RealType="DropDownList"       DescRef="VlanPriority"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.Priority"           InitValue="[{TextRef:'Priority0',Value:'0'}, {TextRef:'Priority1',Value:'1'}, {TextRef:'Priority2',Value:'2'}, {TextRef:'Priority3',Value:'3'}, {TextRef:'Priority4',Value:'4'}, {TextRef:'Priority5',Value:'5'}, {TextRef:'Priority6',Value:'6'}, {TextRef:'Priority7',Value:'7'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="IPv4MXU"                   RealType="TextBox"            DescRef="IPv4MXU"                   RemarkRef="IPv4MXUHELP"        ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4MXU"            InitValue="Empty"/>
<li   id="UserName"                  RealType="TextBox"            DescRef="IPv4UserName"              RemarkRef="IPv4UserNameHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.UserName"           InitValue="Empty"   MaxLength="63"/>
<li   id="Password"                  RealType="TextBox"            DescRef="IPv4Password"              RemarkRef="IPv4PasswordHELP"   ErrorMsgRef="Empty"    Require="FALSE"    BindField="y.Password"           InitValue="Empty"   MaxLength="63"/>
<li   id="LcpEchoReqCheck"           RealType="CheckBox"           DescRef="LcpEchoReqCheck"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.LcpEchoReqCheck"    InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv4BindLanList"           RealType="CheckBoxList"       DescRef="IPv4BindOptions"           RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4BindLanList"    InitValue="[{TextRef:'LAN1',Value:'LAN1'},{TextRef:'LAN2',Value:'LAN2'},{TextRef:'LAN3',Value:'LAN3'},{TextRef:'LAN4',Value:'LAN4'},{TextRef:'LAN5',Value:'LAN5'},{TextRef:'LAN6',Value:'LAN6'},{TextRef:'LAN7',Value:'LAN7'},{TextRef:'LAN8',Value:'LAN8'},{TextRef:'SSID1',Value:'SSID1'},{TextRef:'SSID2',Value:'SSID2'},{TextRef:'SSID3',Value:'SSID3'},{TextRef:'SSID4',Value:'SSID4'},{TextRef:'SSID5',Value:'SSID5'},{TextRef:'SSID6',Value:'SSID6'},{TextRef:'SSID7',Value:'SSID7'},{TextRef:'SSID8',Value:'SSID8'}]" ClickFuncApp="onclick=OnChangeUI"/>                                                                   
<li   id="DstIPForwardingList"       RealType="TextArea"           DescRef="DstIPForwardingCfg"        RemarkRef="DstIPForwardingHelp"  ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.DstIPForwardingList" InitValue="Empty" MaxLength="8192"/>

<li   id="SwitchMode"                RealType="RadioButtonList"    DescRef="SwitchMode"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="s.SwitchMode"         InitValue="[{TextRef:'ManualWireless',Value:'ManualWireless'},{TextRef:'bbsp_auto',Value:'Auto'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="SwitchDelayTime"           RealType="TextBox"            DescRef="SwitchDelayTime"           RemarkRef="SwitchDelayTimeRemark"    ErrorMsgRef="Empty"    Require="TRUE"     BindField="s.SwitchDelayTime"        InitValue="Empty"/>
<li   id="PingIPAddress"             RealType="TextBox"            DescRef="PingIPAddress"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"     BindField="d.PingIPAddress"      InitValue="Empty"    MaxLength="63"/>

<li   id="DialInfoBar"               RealType="HorizonBar"         DescRef="DialInfo"                  RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
<li   id="RadioWanUsername"          RealType="TextBox"            DescRef="IPv4UserName"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.RadioWanUsername"           InitValue="Empty"   MaxLength="31"/>
<li   id="RadioWanPassword"          RealType="TextBox"            DescRef="IPv4Password"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.RadioWanPassword"           InitValue="Empty"   MaxLength="31"/>
<li   id="APN"                       RealType="TextBox"            DescRef="APN"                       RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="t.APN"                InitValue="Empty"   MaxLength="31"/>
<li   id="DialNumber"                RealType="TextBox"            DescRef="DialNumber"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="t.DialNumber"         InitValue="Empty"   MaxLength="15"/>
<li   id="TriggerMode"               RealType="RadioButtonList"    DescRef="TriggerMode"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="t.TriggerMode"        InitValue="[{TextRef:'AlwaysOnline',Value:'AlwaysOn'},{TextRef:'OnDemand',Value:'OnDemand'}]" ClickFuncApp="onclick=OnChangeUI"/>

<li   id="WanIPv4InfoBar"            RealType="HorizonBar"         DescRef="WanIPv4Info"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/> 
<li   id="IPv4AddressMode"           RealType="RadioButtonList"    DescRef="WanIpMode"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4AddressMode"    InitValue="[{TextRef:'Static',Value:'Static'},{TextRef:'DHCP',Value:'DHCP'},{TextRef:'PPPoE',Value:'PPPoE'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv4NatSwitch"             RealType="CheckBox"           DescRef="EnableNat"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4NATEnable"      InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv4NatType"               RealType="DropDownList"       DescRef="NatType"                   RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.NatType"            InitValue="[{TextRef:'Port_Restricted_Cone_NAT',Value:'0'},{TextRef:'Full_Cone_NAT',Value:'1'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="IPv4VendorId"              RealType="TextBox"            DescRef="IPv4VendorId"              RemarkRef="IPv4VendorIdDes"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4VendorId"       InitValue="Empty"   MaxLength="64"/>
<li   id="IPv4ClientId"              RealType="TextBox"            DescRef="IPv4ClientId"              RemarkRef="IPv4ClientIdDes"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4ClientId"       InitValue="Empty"   MaxLength="64"/>
<li   id="IPv4IPAddress"             RealType="TextBox"            DescRef="IPv4IPAddress"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4IPAddress"      InitValue="Empty"/>
<li   id="IPv4SubnetMask"            RealType="TextBox"            DescRef="IPv4SubnetMask"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4SubnetMask"     InitValue="Empty"/>
<li   id="IPv4DefaultGateway"        RealType="TextBox"            DescRef="IPv4DefaultGateway"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4Gateway"        InitValue="Empty"/>
<li   id="IPv4PrimaryDNSServer"      RealType="TextBox"            DescRef="IPv4PrimaryDNSServer"      RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4PrimaryDNS"     InitValue="Empty"/>
<li   id="IPv4SecondaryDNSServer"    RealType="TextBox"            DescRef="IPv4SecondaryDNSServer"    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4SecondaryDNS"   InitValue="Empty"/>
<li   id="IPv4DialMode"              RealType="DropDownList"       DescRef="IPv4DialMode"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4DialMode"       InitValue="[{TextRef:'IPv4DialModeAlwaysOn',Value:'AlwaysOn'},{TextRef:'IPv4DialModeManual',Value:'Manual'},{TextRef:'IPv4DialModeOnDemand',Value:'OnDemand'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="IPv4DialIdleTime"          RealType="TextBox"            DescRef="IPv4IdleTime"              RemarkRef="IPv4IdleTimeRemark" ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv4DialIdleTime"   InitValue="Empty"/>
<li   id="IPv4IdleDisconnectMode"    RealType="DropDownList"       DescRef="IPv4IdleDisconnectMode"    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4IdleDisconnectMode"   InitValue="[{TextRef:'IPv4IdleDisconnectMode_note1',Value:'DetectBidirectionally'},{TextRef:'IPv4IdleDisconnectMode_note2',Value:'DetectUpstream'}]" ClickFuncApp="onchange=OnChangeUI"/>
<li   id="IPv4DialConnectManual"     RealType="InputButtonList"    DescRef="IPv4DialConnectManual"     RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"    		   InitValue="[{TextRef:'IPv4ManualTextRef',Value:'IPv4ManualConnect'},{TextRef:'IPv4ManualTextRef',Value:'IPv4ManualDisonnect'}]"/>   
<li   id="IPv4WanMVlanId"            RealType="TextBox"            DescRef="WanMVlanId"                RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv4WanMVlanId"     InitValue="Empty"/>
<li   id="LanDhcpSwitch"             RealType="CheckBox"           DescRef="EnableLanDhcp"             RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.EnableLanDhcp"      InitValue="Empty" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="RDMode"                    RealType="RadioButtonList"    DescRef="Des6RDMode"                RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="r.RdMode"              InitValue="[{TextRef:'Off',Value:'Off'},{TextRef:'Auto',Value:'Dynamic'},{TextRef:'Static',Value:'Static'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="RdPrefix"                  RealType="TextBox"            DescRef="Des6RDPrefix"              RemarkRef="Empty"       ErrorMsgRef="Empty"    Require="TRUE"     BindField="r.RdPrefix"              InitValue="Empty"/>
<li   id="RdPrefixLen"               RealType="TextBox"            DescRef="Des6RDPrefixLenth"         RemarkRef="RDPreLenthReMark"   ErrorMsgRef="Empty"    Require="TRUE"     BindField="r.RdPrefixLen"              InitValue="Empty"/>
<li   id="RdBRIPv4Address"           RealType="TextBox"            DescRef="Des6RDBrAddr"              RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="r.RdBRIPv4Address"              InitValue="Empty"/>
<li   id="RdIPv4MaskLen"             RealType="TextBox"            DescRef="Des6RDIpv4MaskLenth"       RemarkRef="RDIpv4MskLnReMark"  ErrorMsgRef="Empty"    Require="TRUE"     BindField="r.RdIPv4MaskLen"              InitValue="Empty"/>


<li   id="WanIPv6InfoBar"            RealType="HorizonBar"         DescRef="WanIPv6Info"               RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="Empty"              InitValue="Empty"/>
<li   id="IPv6PrefixMode"            RealType="RadioButtonList"    DescRef="IPv6PrefixMode"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6PrefixMode"     InitValue="[{TextRef:'DHCPPD',Value:'PrefixDelegation',TitleRef:'PrefixDHCPPDTitle'},{TextRef:'Static',Value:'Static',TitleRef:'PrefixStaticTitle'},{TextRef:'None',Value:'None',TitleRef:'PrefixNoneTitle'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv6StaticPrefix"          RealType="TextBox"            DescRef="IPv6StaticPrefix"          RemarkRef="PrefixRemark"       ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv6StaticPrefix"   InitValue="Empty"/>
<li   id="IPv6AddressMode"           RealType="RadioButtonList"    DescRef="WanIpMode"                 RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6AddressMode"    InitValue="[{TextRef:'DHCPV6',Value:'DHCPv6',TitleRef:'AddressDHCPTitle'},{TextRef:'Auto',Value:'AutoConfigured',TitleRef:'AddressAutoTitle'},{TextRef:'Static',Value:'Static',TitleRef:'AddressStaticTitle'},{TextRef:'None',Value:'None',TitleRef:'AddressNoneTitle'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv6ReserveAddress"        RealType="TextBox"            DescRef="IPv6ReserveAddress"        RemarkRef="IPv6ReserveAddressNote" ErrorMsgRef="Empty" Require="FALSE"   BindField="d.IPv6ReserveAddress" InitValue="Empty"/>
<li   id="IPv6AddressStuff"          RealType="TextBox"            DescRef="IPv6AddressStuff"          RemarkRef="StuffRemark"        ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6AddressStuff"   InitValue=""TitleRef="AddressStuffTitle"/>
<li   id="IPv6IPAddress"             RealType="TextBox"            DescRef="IPv4IPAddress"             RemarkRef="IPv6AddressRemark"  ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv6IPAddress"      InitValue="Empty"/>
<li   id="IPv6AddrMaskLenE8c"        RealType="TextBox"            DescRef="IPv6AddrMaskLenE8c"     RemarkRef="IPv6AddrMaskLenE8cRemark"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6AddrMaskLenE8c"    InitValue="Empty"/>
<li   id="IPv6GatewayE8c"            RealType="TextBox"            DescRef="IPv6GatewayE8c"         RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6GatewayE8c"    InitValue="Empty"/>
<li   id="IPv6SubnetMask"            RealType="TextBox"            DescRef="IPv4SubnetMask"            RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv6SubnetMask"     InitValue="Empty"/>
<li   id="IPv6DefaultGateway"        RealType="TextBox"            DescRef="IPv4DefaultGateway"        RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="TRUE"     BindField="d.IPv6Gateway"        InitValue="Empty"/>
<li   id="IPv6PrimaryDNSServer"      RealType="TextBox"            DescRef="IPv4PrimaryDNSServer"      RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6PrimaryDNS"     InitValue="Empty"/>
<li   id="IPv6SecondaryDNSServer"    RealType="TextBox"            DescRef="IPv4SecondaryDNSServer"    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6SecondaryDNS"   InitValue="Empty"/>
<li   id="IPv6WanMVlanId"            RealType="TextBox"            DescRef="WanMVlanId"                RemarkRef="WanVlanIdRemark"    ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6WanMVlanId"     InitValue="Empty"/>
<li   id="IPv6DSLite"                RealType="RadioButtonList"    DescRef="DSLite"                    RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6DSLite"         InitValue="[{TextRef:'Off',Value:'Off'},{TextRef:'Auto',Value:'Dynamic'},{TextRef:'Static',Value:'Static'}]" ClickFuncApp="onclick=OnChangeUI"/>
<li   id="IPv6AFTRName"              RealType="TextBox"            DescRef="AFTRName"                  RemarkRef="Empty"              ErrorMsgRef="Empty"    Require="FALSE"    BindField="d.IPv6AFTRName"       InitValue="Empty"   MaxLength="256"/>
</table>
<script>
var WanConfigFormList = [];
var dir_style = ("ARABIC" == LoginRequestLanguage.toUpperCase()) ? "rtl" : "ltr";
var TableClass = new stTableClass("width_per25", "width_per75", dir_style, "Select");
WanConfigFormList = HWGetLiIdListByForm("ConfigForm",WanReload);
HWParsePageControlByID("ConfigForm", TableClass, Languages, WanReload);

ParsePageSpec();
CleanServiceListVoip();
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

<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
    <tr>
        <td width="25%">
        </td>
        <td class="table_submit" style="padding-left: 5px">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            <input id="ButtonApply"  type="button" value="OK" onclick="javascript:return OnApply();" class="ApplyButtoncss buttonwidth_100px" />
            <input id="ButtonCancel" type="button" value="Cancel" onclick="javascript:OnCancel();" class="CancleButtonCss buttonwidth_100px" />
        </td>
    </tr>
</table>
<table width="100%" height="20" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
</table> 
<script>setText("ButtonApply", GetLanguage("Apply"));setText("ButtonCancel", GetLanguage("Cancel"));</script>

<script>DisplayConfigPanel(0);</script>
</form>
<script>
function ClickPre(val)
{
	if("chinese" == curLanguage)
	{
		val.name = '/html/amp/ontauth/password.asp';
	}
	else
	{
		val.name = '/html/amp/ontauth/passwordcommon.asp';
	}
	window.parent.onchangestep(val);
}

function ClickSkip(val)
{
	val.id = "guidecfgdone";
	window.parent.onchangestep(val);
}
</script>

<div align="center">
<div id="btnguidewan" border="0" cellpadding="0" cellspacing="0" class="contentItem nofloat" style="display:none;">
	<div class="labelBox"></div>
	<div class="contenbox nofloat">
		<input type="button" id="guideontauth" name="/html/amp/ontauth/password.asp"     class="CancleButtonCss buttonwidth_100px" onClick="ClickPre(this);" BindText="bbsp_pre"/>
		<input type="button" id="guidecfgdone" name="/html/ssmp/bss/guidebssinfo.asp" class="ApplyButtoncss buttonwidth_100px"  onClick="window.parent.onchangestep(this);"  BindText="bbsp_next"/>
		<a id="guideskip" name="/html/ssmp/bss/guidebssinfo.asp" href="#" onClick="ClickSkip(this);">
			<span BindText="bbsp_skip"></span>
		</a>
	</div>
</div>
</div>
<script>
	ParseBindTextByTagName(guideinternet_language, "span", 1);
	ParseBindTextByTagName(guideinternet_language, "input", 2);
</script>
</body>
</html>
