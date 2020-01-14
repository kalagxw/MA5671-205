<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
function stBatteryModePolicy(domain,Usb,Lan,Wlan,Voice,Catv,RemoteManagement)
{
	this.domain = domain;
	this.Usb = Usb;
	this.Lan = Lan;
	this.Wlan = Wlan;
	this.Voice = Voice;
	this.Catv = Catv;
	this.RemoteManagement = RemoteManagement;
}

function stApmFt(IsSuportBattery,IsSuportLAN,IsSuportRF,IsSuportVoice,IsSuportWlan,IsSuportUsb)
{
	this.IsSuportBattery = IsSuportBattery;
	this.IsSuportLAN = IsSuportLAN;
	this.IsSuportRF = IsSuportRF;
	this.IsSuportVoice = IsSuportVoice;
	this.IsSuportWlan = IsSuportWlan;
	this.IsSuportUsb = IsSuportUsb;
}

var EnablePowerSavingMode = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.EnablePowerSavingMode);%>;  

var stBatteryMode = new Array(new stBatteryModePolicy("0","0","0","0", "0", "0", "0"),null);
stBatteryMode.Usb = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseUsbService);FT=HW_SSMP_FEATURE_USB&USER=3%>';
stBatteryMode.Lan = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseLanService);FT=HW_SSMP_FEATURE_APMLAN&USER=3%>';  
stBatteryMode.Wlan = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseWlanService);FT=HW_SSMP_FEATURE_APMWLAN&USER=3%>';  
stBatteryMode.Voice = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseVoiceService);FT=HW_SSMP_FEATURE_APMVOICE&USER=3%>';  
stBatteryMode.Catv = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseCATVService);FT=HW_SSMP_FEATURE_APMRF&USER=3%>';  
stBatteryMode.RemoteManagement = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy.NotUseRemoteManagement);%>';  

var ApmFt = new Array(new stApmFt("0","0","0","0", "0", "0"),null);
ApmFt.IsSuportBattery = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_BATTERY);%>';
ApmFt.IsSuportLAN = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMLAN);%>';
ApmFt.IsSuportRF = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMRF);%>';
ApmFt.IsSuportVoice = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMVOICE);%>';
ApmFt.IsSuportWlan = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_APMWLAN);%>';
ApmFt.IsSuportUsb = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_USB);%>';

var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';

function ConvertValue(para)
{
	if(0 == para)
	{ 
		return 1;
	}
	else
	{
		return 0;
	}
}

function setAllDisable()
{
	setDisable('PowerSaveEnable',1);
	setDisable('NotUseUsbDEFHIDE',1);
	setDisable('NotUseLanDEFHIDE',1);
	setDisable('NotUseWLanDEFHIDE',1);
	setDisable('NotUseVoiceDEFHIDE',1);
	setDisable('RemoteManagement',1);
	setDisable('btnApply',1);
	setDisable('cancelValue',1);
}

function LoadFrame()
{	
	setCheck('PowerSaveEnable',EnablePowerSavingMode);
  	setCheck('NotUseUsbDEFHIDE',ConvertValue(stBatteryMode.Usb));
	setCheck('NotUseLanDEFHIDE',ConvertValue(stBatteryMode.Lan));
	setCheck('NotUseWLanDEFHIDE',ConvertValue(stBatteryMode.Wlan));
	setCheck('NotUseVoiceDEFHIDE',ConvertValue(stBatteryMode.Voice));
	setCheck('NotUseCatvDEFHIDE',ConvertValue(stBatteryMode.Catv));
	setCheck('RemoteManagement',ConvertValue(stBatteryMode.RemoteManagement));
	
	var pots_flag  =  parseInt(productName.charAt(3));
	var eth_flag   =  parseInt(productName.charAt(4));
	var wifi_flag  =  parseInt(productName.charAt(5)) & 4; 
	var rf_flag    =  parseInt(productName.charAt(5)) & 2; 
	var usb_flag   =  parseInt(productName.charAt(5)) & 1; 

	if (0 != ApmFt.IsSuportBattery)
	{
		setDisplay('batteryset',1); 
	}
	
	if(0 != ApmFt.IsSuportUsb)
	{
		setDisplay('NotUseUsbDEFHIDERow', 1);
	}
	
	if(0 != ApmFt.IsSuportLAN)
	{
		setDisplay('NotUseLanDEFHIDERow', 1);
	}
	
	if(0 != ApmFt.IsSuportWlan)
	{
		setDisplay('NotUseWLanDEFHIDERow', 1);
	}
	
	if(0 != ApmFt.IsSuportVoice)
	{
		setDisplay('NotUseVoiceDEFHIDERow', 1);
	}
	
	if(0 != ApmFt.IsSuportRF)
	{
		setDisplay('NotUseCatvDEFHIDERow', 1);
	}
	
	if((curWebFrame == 'frame_argentina') &&(curUserType != sysUserType))
	{
		setAllDisable();
	}
}

function FormCheck()
{
	return true;
}

function SubmitForm()
{
	if(false == FormCheck())
    {
        return;
    }

	setDisable('btnApply', 1);
    setDisable('cancelValue', 1);
		
    var Form = new webSubmitForm();
    
	if(0 != ApmFt.IsSuportBattery)
	{
		Form.usingPrefix('x');
		
		if(0 != ApmFt.IsSuportUsb)
		{
			Form.addParameter('NotUseUsbService',ConvertValue(getCheckVal('NotUseUsbDEFHIDE')));
		}
		
		if(0 != ApmFt.IsSuportLAN)
		{
			Form.addParameter('NotUseLanService',ConvertValue(getCheckVal('NotUseLanDEFHIDE')));
		}
		
		if(0 != ApmFt.IsSuportWlan)
		{
			Form.addParameter('NotUseWlanService',ConvertValue(getCheckVal('NotUseWLanDEFHIDE')));
		}
		
		if(0 != ApmFt.IsSuportVoice)
		{
			Form.addParameter('NotUseVoiceService',ConvertValue(getCheckVal('NotUseVoiceDEFHIDE')));
		}
		
		if(0 != ApmFt.IsSuportRF)
		{
			Form.addParameter('NotUseCATVService',ConvertValue(getCheckVal('NotUseCatvDEFHIDE')));
		}

		Form.addParameter('NotUseRemoteManagement',ConvertValue(getCheckVal('RemoteManagement')));
		Form.endPrefix();
	}
    
    Form.addParameter('y.EnablePowerSavingMode',getCheckVal('PowerSaveEnable'));
	
	if (0 != ApmFt.IsSuportBattery)
	{
		Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_APMPolicy.BatteryModePolicy&y=InternetGatewayDevice.X_HW_APMPolicy&RequestFile=html/ssmp/apm/apmcfg.asp');
	}
	else
	{
		Form.setAction('set.cgi?y=InternetGatewayDevice.X_HW_APMPolicy&RequestFile=html/ssmp/apm/apmcfg.asp');	
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();			  
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("apmcfg", GetDescFormArrayById(ApmcfgLgeDes, "s0100"), GetDescFormArrayById(ApmcfgLgeDes, "s0e01"), false);
</script>
<div class="title_spread"></div> 
<div class="func_title" BindText="s0e02"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
  <tr> 
    <td class="table_title width_per20" BindText="s0e03"></td> 
    <td class="table_right"> <input value='PowerSaveEnable' type='checkbox' name='PowerSaveEnable' id="PowerSaveEnable" checked> </td> 
  </tr> 
</table>
<div id = 'batteryset' style="display:none">
<div class="func_spread"></div> 
<div class="func_title" BindText="s0e04"></div> 
<form id="apmcfgForm" name="apmcfgForm">
<table id="apmcfgFormPanel" width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg">
<li id="ServiceEnable" RealType="HtmlText" DescRef="s0e05" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="ServiceEnable" InitValue="Empty" />
<li id="NotUseUsbDEFHIDE" RealType="CheckBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NotUseUsbDEFHIDE" InitValue="Empty" /> 
<li id="NotUseLanDEFHIDE" RealType="CheckBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NotUseLanDEFHIDE" InitValue="Empty" /> 
<li id="NotUseWLanDEFHIDE" RealType="CheckBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NotUseWLanDEFHIDE" InitValue="Empty" /> 
<li id="NotUseVoiceDEFHIDE" RealType="CheckBox" DescRef="s0e0a" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NotUseVoiceDEFHIDE" InitValue="Empty" /> 
<li id="NotUseCatvDEFHIDE" RealType="CheckBox" DescRef="Empty" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="NotUseCatvDEFHIDE" InitValue="Empty" /> 
<li id="RemoteManagement" RealType="CheckBox" DescRef="s0e07" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="RemoteManagement" InitValue="Empty" /> 
</table>
<script>
var TableClassSecond = new stTableClass("table_title width_per20", "table_right align_left","ltr");
var ApmCfgInfoFormList = new Array();
ApmCfgInfoFormList = HWGetLiIdListByForm("apmcfgForm",null);
HWParsePageControlByID("apmcfgForm",TableClassSecond,ApmcfgLgeDes,null);
document.getElementById('ServiceEnable').innerHTML = ApmcfgLgeDes['s0e06'];
document.getElementById('NotUseUsbDEFHIDEColleft').innerHTML = "USB:";
document.getElementById('NotUseLanDEFHIDEColleft').innerHTML = "LAN:";
document.getElementById('NotUseWLanDEFHIDEColleft').innerHTML = "WLAN:";
document.getElementById('NotUseCatvDEFHIDEColleft').innerHTML = "CATV:";
</script>
</form>
</div>
<table id="AmpCfgButtons" width="100%"  border="0" cellspacing="1" cellpadding="0" class="table_button"> 
  <tr>
	<td class="table_submit width_per20"></td> 
    <td class="table_submit"> <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<input class="ApplyButtoncss buttonwidth_100px" name="btnApply" id= "btnApply" type="button" BindText="s0e08" onClick="SubmitForm();"> 
	<input class="CancleButtonCss buttonwidth_100px" name="cancelValue" id="cancelValue" type="button" BindText="s0e09" onClick="CancelConfig();"></td> 
  </tr> 
</table>

<script>
ParseBindTextByTagName(ApmcfgLgeDes, "div",    1);
ParseBindTextByTagName(ApmcfgLgeDes, "td",     1);
ParseBindTextByTagName(ApmcfgLgeDes, "input",  2);
</script>
</body>
</html>
