<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Internet Mode Translation</title>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="javascript" src="../common/wan_list_info.asp"></script>
<script language="javascript" src="../common/wan_list.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

function stLayer3Enable(domain, lay3enable)
{
	this.domain = domain;
	this.lay3enable = lay3enable;
}
var Lay3Enables = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.LANDevice.1.LANEthernetInterfaceConfig.{i}, X_HW_L3Enable,stLayer3Enable);%>;

function TopoInfo(Domain, EthNum, SSIDNum)
{   
    this.Domain = Domain;
    this.EthNum = EthNum;
    this.SSIDNum = SSIDNum;
}
var TopoInfoList = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Topo,X_HW_EthNum|X_HW_SsidNum,TopoInfo);%>
var TopoInfo = TopoInfoList[0];

function CheckWanConfigValid()
{
	var WanList = GetWanList();
	var InternetWanNum = 0;
	var InternetWanIdx = 0;
	
	for (var i = 0; i < WanList.length; i++)
	{
		if (WanList[i].Name.toUpperCase().indexOf("INTERNET") >= 0)
		{
			InternetWanNum++;
			InternetWanIdx = i;
		}
	}
	if (InternetWanNum != 1)
	{
		return -1;
	}
	
	return InternetWanIdx;
}

function GetLayer3LanPortNum()
{
	var Layer3LanPortNum = 0;
	
	for (var i = 0; i < Lay3Enables.length; i++)
	{
		if ((Lay3Enables[i] != null) && (Lay3Enables[i].lay3enable == 1))
		{
			Layer3LanPortNum++;
		}
	}
	
	return Layer3LanPortNum;
}

function GetLanPortNumOfBindWan(InternetWanIdx)
{
	var WanList  = GetWanList();
	var BindList = GetLanWanBindInfo(WanList[InternetWanIdx].NewName);		
	if (BindList.PhyPortName.toUpperCase().indexOf("LAN") < 0)
	{
		return 0;
	}
	
	var PortList = BindList.PhyPortName.split(',');
	var LanPortNum = 0;
	for (var i = 0; i < PortList.length; i++)
	{
		if (PortList[i].toUpperCase().indexOf("LAN") >= 0)
		{
			LanPortNum++;
		}
	}
	
	return LanPortNum;
}

function GetOntCurrentMode()
{
	var InternetWanIdx = CheckWanConfigValid();	
	
	setDisable("TranslateToRouteMode", "1");
	setDisable("TranslateToBridgeMode", "1");
	
	if (InternetWanIdx < 0)
	{
		return 0;
	}
	
	var WanList = GetWanList();
	var Layer3LanPortNum = GetLayer3LanPortNum();
	var LanPortNumOfBindWan = GetLanPortNumOfBindWan(InternetWanIdx);
	
	if (WanList[InternetWanIdx].Enable == 1)
	{
		if ((Layer3LanPortNum != TopoInfo.EthNum) || (LanPortNumOfBindWan != TopoInfo.EthNum))
		{
			return 0;
		}
		
		return 1;
	}
	else
	{
		if ((Layer3LanPortNum != 0) || (LanPortNumOfBindWan != 0))
		{
			return 0;
		}
		
		return 2;
	}
}

function GetOntCurrentModeName()
{
	var OntInternetMode = GetOntCurrentMode();
	
	if (1 == OntInternetMode)
	{
		return InternetMode_language['bbsp_internetmode_route'];
	}
	else if (2 == OntInternetMode)
	{
		return InternetMode_language['bbsp_internetmode_bridge'];
	}
	else
	{
		return InternetMode_language['bbsp_internetmode_unknown'];
	}
}

function OnTranslateToRouteMode()
{
	var InternetWanIdx = CheckWanConfigValid();
	
	if (InternetWanIdx < 0)
	{
		AlertEx(InternetMode_language['bbsp_internetmode_warning']);
		return;
	}
    
    setDisable("TranslateToRouteMode", "1");
    
    var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('setinternettoroute.cgi?RequestFile=html/bbsp/internetmodeswitch/internetmodeswitch.asp');   
    Form.submit();
}

function OnTranslateToBridgeMode()
{
	var InternetWanIdx = CheckWanConfigValid();
	
	if (InternetWanIdx < 0)
	{
		AlertEx(InternetMode_language['bbsp_internetmode_warning']);
		return;
	}
	
	setDisable("TranslateToBridgeMode", "1");
	
    var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('setinternettobridge.cgi?RequestFile=html/bbsp/internetmodeswitch/internetmodeswitch.asp');   
    Form.submit();
}

function LoadFrame()
{
	var OntInternetMode = GetOntCurrentMode();
	
	if (1 == OntInternetMode)
	{
		setDisable("TranslateToRouteMode", "1");
		setDisable("TranslateToBridgeMode", "0");
	}
	else if (2 == OntInternetMode)
	{
		setDisable("TranslateToRouteMode", "0");
		setDisable("TranslateToBridgeMode", "1");
	}
	else
	{
		setDisable("TranslateToRouteMode", "0");
		setDisable("TranslateToBridgeMode", "0");
	}
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<form id="ConfigForm" action=""> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("internetmodeswitchtitle", GetDescFormArrayById(InternetMode_language, ""), GetDescFormArrayById(InternetMode_language, "bbsp_internetmode_desc"), false);
</script>
<div class="title_spread"></div>
 
  <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%">
	<tr>
		<td class="table_title width_per25"><script>document.write(InternetMode_language['bbsp_internetmode_current']);</script></td>
		<td class="table_right"><span id="CurrentMode" class='width_20px'><script>document.write(GetOntCurrentModeName());</script></span></td>
	</tr> 
  </table> 
  <table cellpadding="0" cellspacing="0" class="tabal_bg" width="100%">
    <tr> 
      <td class='table_title width_per25'></td> 
      <td class="table_submit width_per30 align_left">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	  	<button name="TranslateToRouteMode" id="TranslateToRouteMode" type="button" class="submit" onClick="OnTranslateToRouteMode();"><script>document.write(InternetMode_language['bbsp_internetmode_routemode']);</script></button>
	 </td>
	 <td class="table_submit align_left">
        <button name="TranslateToBridgeMode" id="TranslateToBridgeMode" type="button" class="submit" onClick="OnTranslateToBridgeMode();"><script>document.write(InternetMode_language['bbsp_internetmode_bridgemode']);</script></button> 
	</td> 
    </tr>
  </table>  
</form>
</body>
</html>
