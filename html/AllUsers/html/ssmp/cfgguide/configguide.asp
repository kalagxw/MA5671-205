<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="javascript" src="../../bbsp/common/topoinfo.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list_info.asp"></script>
<script language="javascript" src="../../bbsp/common/wan_list.asp"></script>
<script language="javascript" src="../../amp/common/wlan_list.asp"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var waniplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANIPConnection.{i}.X_HW_LANBIND,Lan1Enable|Lan2Enable|Lan3Enable|Lan4Enable,stLanbindInfo);%>;
var wanppplanbind = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.WANDevice.1.WANConnectionDevice.{i}.WANPPPConnection.{i}.X_HW_LANBIND,Lan1Enable|Lan2Enable|Lan3Enable|Lan4Enable,stLanbindInfo);%>;
var TopoInfo = GetTopoInfo();
var Wan = GetWanList();
var curWandomain = "";
var curEnterStyle = "";

if(window.location.href.indexOf("configguide.asp?") > 0)
{
	var currentUrl = window.location.href;
	var tempId = (currentUrl.split("?"))[1];
	if(tempId != "")
	{
		AlertEx(" Link ");
		curEnterStyle = "Link";
	}
}
else
{
	curEnterStyle = "Direct";
}
	
function GetLanguageDesc(Name)
{
    return CfgguideLgeDes[Name];
}

function IsWlanAvailable()
{
	if(1 == '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_WLAN);%>')
	{
		return true;
	}
	else
	{
		return false;
	}
}

function stLanbindInfo(domain,lan1enable,lan2enable,lan3enable,lan4enable)
{
	this.domain = domain;
	this.lan1enable = lan1enable;
	this.lan2enable = lan2enable;
	this.lan3enable = lan3enable;
	this.lan4enable = lan4enable;
}

function IsOtherWanAvailable()
{
	for(var i = 0; i < Wan.length; i++)
	{
		if(Wan[i].ServiceList.indexOf("OTHER") >= 0)
		{
			return true;
		}
	}
	return false;
}


function GetFirstInternetWan()
{
	for(var i = 0; i < Wan.length; i++)
	{
		if(Wan[i].ServiceList.indexOf("INTERNET") >= 0  && 'PPPoE' == Wan[i].EncapMode) 
		{
			return Wan[i];
		}
	}
	return false;
}

function GetCurrentInternetWan()
{
	var curUrl = window.location.href;
	var curMacId = (curUrl.split("?"))[1];
	var Wan = GetWanList();
	for(var i = 0; i < Wan.length; i++)
	{
		if (Wan[i].MacId == curMacId )
		{
		    return Wan[i];
		}
	}
	return false;
}

function GetWlanEnable()
{
	var wlanEnbl = getCheckVal('Wizard_checkbox02_checkbox');
	if (wlanEnbl == 1)
	{
		return "Enabled";
	}
	else
	{
		return "Disabled";
	}
}

function HideAll()
{
	setDisplay('wizard1', 0);
	setDisplay('wizard2', 0);
	setDisplay('wizard5', 0);
}

function stNormalUserInfo(UserName, ModifyPasswordFlag)
{
    this.UserName = UserName;
    this.ModifyPasswordFlag = ModifyPasswordFlag;	
}

function LoadFrame()
{
	HideAll();
	setDisplay('wizard1', 1);
}

function isAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch < ' ' || ch > '~' )
        {
            return false;
        }
    }
    return true;
}

function CheckFormStep1()
{
	var UserName = getValue('pppoe_wan_name');
	var Password = getValue('pppoe_wan_pwd');

	if(false == GetFirstInternetWan())
	{
		AlertEx("No PPPoE WAN.");
		return false;
	}

    if ((UserName == '') || (Password == ''))
    {
    	if (ConfirmEx('The PPPoE username or password is empty. Do you want to continue?') == false)
    	{
    		return false;
    	}
    }
	
	if ((UserName != '') && (isValidAscii(UserName) != ''))        
	{  
		AlertEx(Languages['IPv4UserName1'] + Languages['Hasvalidch'] + isValidAscii(UserName) + '"。');          
		return false;       
	}

	if ((Password != '') && (isValidAscii(Password) != ''))         
	{  
		AlertEx(Languages['IPv4Password1'] + Languages['Hasvalidch'] + isValidAscii(Password) + '"。');         
		return false;       
	}
		
	return true;
}

function GetLanguageDesc(Name)
{
    return CfgguideLgeDes[Name];
}

function NextStep1()
{
	if(false == CheckFormStep1())
	{
		return false;
	}
	
	HideAll();
	if(IsWlanAvailable())
	{	
		setDisplay('wizard2',1);
	}
	
}

function ShowWifiForm()
{
	HideAll();
    setDisplay('wizard2',1);
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
<br>
<div id="wizard1">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_head">
<tr><td class="table_head" width="100%"><label id="Title_wizard2_lable">PPPoE Account Configuration</label></td></tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="1" id="Wizard1Panel" class="tabal_bg"> 
	<tr>
	<td class="table_title width_25p">PPPoE Username:</td> 
	<td class="table_right width_75p"> <input type="text" id="pppoe_wan_name" maxlength="63"></td> 
  </tr>
  <tr>
	<td class="table_title width_25p" >PPPoE Password:</td> 
	<td class="table_right width_75p"> <input type="password" id="pppoe_wan_pwd" maxlength="63" > </td> 
  </tr>              
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="wizard1_table2"> 
  <tr><td class="table_submit width_25p" align="right"></td>
	<td class="table_submit "><input class="submit" id="Wizard_button1_2_button" type="button" onClick="NextStep1();"  value="Next"> <td>
  </tr>         
</table>
</div>

<div id="wizard2">
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_head">
<tr><td class="table_head" width="100%"><label id="Title_wizard2_lable">Wireless Bandwidth Configuration</label></td></tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr>
	<td class="table_right" width="25%">WiFi Enabled</td>
	<td class="table_title"  width="75%"><input checked type='checkbox' id='Wizard_checkbox02_checkbox' name='Wizard_checkbox02_checkbox'></td>
    
	</tr>
	<tr>
		<td class="table_title"  width="25%">WiFi SSID:&nbsp;</td>
		<td class="table_right" width="75%">
		<input type="text" name="Wizard_text02_text" id="Wizard_text02_text" style="width:123px" maxlength="32">
			<font class="color_red">*</font><span class="gray">
			<script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></span>
		</td>
	</tr>
	<tr>
		<td class="table_title"  width="25%">WiFi Password:&nbsp;</td>
		<td class="table_right" width="75%">
		<input type='password' id='Wizard_password02_password' name='Wizard_password02_password' style="width:123px" maxlength='64' class="amp_font"  onchange="" />
			<font class="color_red">*</font><span class="gray"><script>document.write(cfg_wlancfgdetail_language['amp_wpa_psknote']);</script></span>
		</td>
	</tr>
</table>

<script language="JavaScript" type="text/javascript">
function ltrim(str)
{ 
 return str.replace(/(^\s*)/g,""); 
}

function stWlan(domain,ssid,BeaconType)
{
    this.domain = domain;
    this.ssid = ssid;
    this.BeaconType = BeaconType;
}

var WlanArr = <%HW_WEB_CmdGetWlanConf(InternetGatewayDevice.LANDevice.1.WLANConfiguration.{i},SSID|BeaconType, stWlan);%>;
var Wlan = WlanArr[0];

function CheckSsid()
{
	var ssid = ltrim(getValue('Wizard_text02_text'));
	if (ssid == '')
    {
        AlertEx(cfg_wlancfgother_language['amp_empty_ssid']);
        return false;
    }

    if (ssid.length > 32)
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_too_loog']);
        return false;
    }

    if (isValidAscii(ssid) != '')
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidAscii(ssid));
        return false;
    }

    if (isValidStr(ssid) != '')
    {
        AlertEx(cfg_wlancfgother_language['amp_ssid_check1'] + ssid + cfg_wlancfgother_language['amp_ssid_invalid'] + isValidStr(ssid));
        return false;
    }

	if(0 == WlanArr.length)
	{
		AlertEx("Please create a new instance of the configuration WLAN!");
		return false;
	}
	
    for (i = 1; i < WlanArr.length - 1; i++)
    {
        if (WlanArr[i].ssid == ssid)
		{
			AlertEx(cfg_wlancfgother_language['amp_ssid_exist']);
			return false;
		}
        else
        {
            continue;
        }
    }
	
	return true;
}

function CheckPsk()
{
	var value = getValue('Wizard_password02_password');
	
	if (value == '')
	{
		AlertEx(cfg_wlancfgother_language['amp_empty_para']);
		return false;
	}
	
	if (isValidWPAPskKey(value) == false)
	{
		AlertEx(cfg_wlancfgdetail_language['amp_wpskey_invalid']);
		return false;
	}

	if (isValidStr(value) != '')
	{
		AlertEx(cfg_wlancfgdetail_language['amp_wpa_psk'] + " "+ value + cfg_wlancfgother_language['amp_wlanstr_invalid'] + " " + isValidStr(value));
		return false;
	}

	return true;
}

function WlanPrevious()
{
	HideAll();
	setDisplay('wizard1',1);
}

function WlanAddFormPara(Form)
{
	Form.addParameter('o.X_HW_WlanEnable',getCheckVal('Wizard_checkbox02_checkbox'));

	if ((Wlan.BeaconType == 'WPA') || (Wlan.BeaconType == 'WPA2') || (Wlan.BeaconType == '11i') || (Wlan.BeaconType == 'WPAand11i') || (Wlan.BeaconType == 'WPA/WPA2'))
	{
		Form.addParameter('p.BeaconType',Wlan.BeaconType);
	}
	else
	{
		Form.addParameter('p.BeaconType','WPAand11i');
	}

	Form.addParameter('p.SSID', getValue('Wizard_text02_text'));

	Form.addParameter('q.PreSharedKey', getValue('Wizard_password02_password'));
}

function WlanNext()
{
	if (false == CheckSsid())
	{
		return false;
	}
	
	if (false == CheckPsk())
	{
		return false;
	}

	return true;
}

function showallconfigdata()
{
	if(false == WlanNext())
	{
		return false;
	}

	HideAll();
	setDisplay('wizard5',1);
	
	setDisplay('internetinfo',1);
	setDisplay('tr_internet_user',1);
	setDisplay('tr_internet_pwd',1);
	document.getElementById('internet_user').innerHTML= getValue('pppoe_wan_name');
	document.getElementById('internet_pwd').innerHTML= getValue('pppoe_wan_pwd');
	
	if (true == IsWlanAvailable())
	{
		setDisplay('wlaninfo', 1);
		document.getElementById('wlan_enable').innerHTML= GetWlanEnable();
		document.getElementById('wlan_ssid').innerHTML= getValue('Wizard_text02_text');
		document.getElementById('wlan_psk').innerHTML= getValue('Wizard_password02_password');
	}
}


function InternetWanAddPara(Form)
{
	var UserName = getValue('pppoe_wan_name');
	var Password = getValue('pppoe_wan_pwd');
	var ConfigWan = GetFirstInternetWan();
	if(null == ConfigWan)
	{
		return "Ignore";
	}
	curWandomain = ConfigWan.domain
	if("IP_ROUTED" == ConfigWan.Mode.toString().toUpperCase())
	{
		Form.addParameter('y.Username',UserName);
		Form.addParameter('y.Password',Password);
	}
	else
	{
		Form.addParameter('y.ConnectionType',"IP_Routed");
		Form.addParameter('y.Username',UserName);
		Form.addParameter('y.Password',Password);
	}	
	
	return "success";
}

function OnfinishStep()
{
	var Form = new webSubmitForm();
	
	setDisable('Wizard_button5_1_button', 1);
	setDisable('Wizard_button5_2_button', 1);

	var url = 'set.cgi?';

	if("Ignore" != InternetWanAddPara(Form))
	{
		url +='&y='+curWandomain;
	}
	
	if ((true == IsWlanAvailable()) && (null != Wlan))
	{
		WlanAddFormPara(Form);
		url += '&p=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1' + '&q=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1' + 
			'&o=InternetGatewayDevice.LANDevice.1';
	}
	
	url += '&RequestFile=html/ssmp/cfgguide/configguide.asp';
	Form.setAction(url);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td  class="table_submit" width="25%"></td> 
		<td class="table_submit">
		<input class="submit" name="Wizard_button2_1_button" id="Wizard_button2_1_button" type="button" onClick="WlanPrevious();"  value="Previous"> 
      	<input class="submit" name="Wizard_button2_2_button" id="Wizard_button2_2_button" type="button" onClick="showallconfigdata();"  value="Next"> 
		</td>
	</tr>
</table>
</div>

<div id="wizard5"> 
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="tabal_head">
<tr><td class="table_head" width="100%"><label id="Title_wizard2_lable">Configurations to Confirm</label></td></tr>
</table>
<table id="internetinfo" width="100%" border="0" cellpadding="0" cellspacing="1" style="display:none" class="tabal_bg">
	<tr id="tr_internet_user"> 
	<td class="table_title" width="25%">PPPoE Username</td>
	<td class="table_right" width="75%" id="internet_user"></td>
	</tr>
	<tr id="tr_internet_pwd"> 
	<td class="table_title" width="25%">PPPoE Password</td>
	<td class="table_right" width="75%" id="internet_pwd"></td>
	</tr>
</table>

<table id="wlaninfo" width="100%" border="0" cellpadding="0" cellspacing="1" style="display:none" class="tabal_bg">
	<tr> 
	<td class="table_title" width="25%">WiFi Status</td>
	<td class="table_right" width="75%" id="wlan_enable"></td>
	</tr>
	<tr > 
	<td class="table_title" width="25%">WiFi SSID</td>
	<td class="table_right" width="75%" id="wlan_ssid"></td>
	</tr>
	<tr > 
	<td class="table_title" width="25%">WiFi Password</td>
	<td class="table_right" width="75%" id="wlan_psk"></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="tabal_bg">
  <tr> 
    <td class="table_submit" width="25%"></td> 
    <td class="table_submit">
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input  class="submit" name="MdyPwdApply" id="Wizard_button5_1_button" type="button" onClick="ShowWifiForm();" value="Previous"> 
      <input  class="submit" name="MdyPwdcancel" id="Wizard_button5_2_button" type="button" onClick="OnfinishStep();"  value="Apply"> 
	</td> 
  </tr> 
</table> 
</div>
<script>
var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = CfgguideLgeDes[c];
}

var all = document.getElementsByTagName("input");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.value = CfgguideLgeDes[c];
}
</script>

</body>
</html>
