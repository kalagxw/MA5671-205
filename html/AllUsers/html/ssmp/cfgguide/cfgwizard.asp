<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
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

if(window.location.href.indexOf("cfgwizard.asp?") > 0)
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

function radioChooseMode()
{
	var ModeVal = getRadioVal('wizard1Mode');
	if('1' == ModeVal)
	{
		setDisplay("Wizard1Panel",0);
	}
	else
	{
		setDisplay("Wizard1Panel",1);
	}
}

function GetWlanCheck()
{
    var enable = getCheckVal('Wizard_checkbox02_checkbox');

    return enable;
}

function GetWlanEnable()
{
	if (GetWlanCheck() == 1)
	{
		return "开启";
	}
	else
	{
		return "关闭";
	}
}

function GetiTVEnable()
{
	return "开启";
}

function GetInternetMode()
{
	var ModeVal = getRadioVal('wizard1Mode');
	if('1' == ModeVal)
	{
		return "电脑拨号";
	}
	else
	{
		return "网关拨号";
	}
}

function HideAll()
{
	setDisplay('wizard1', 0);
	setDisplay('wizard2', 0);
	setDisplay('wizard3', 0);
	setDisplay('wizard4', 0);
	setDisplay('wizard5', 0);
}

function stNormalUserInfo(UserName, ModifyPasswordFlag)
{
    this.UserName = UserName;
    this.ModifyPasswordFlag = ModifyPasswordFlag;	
}

var UserInfo = <%HW_WEB_GetNormalUserInfo(stNormalUserInfo);%>;

var sptUserName = UserInfo[0].UserName;

var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>'; 

function CheckPwdIsComplex(str)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}
	
	if (!CompareString(str, TextTranslate(sptUserName)))
	{
		return false;
	}
	
	if ( isLowercaseInString(str) )
	{
		i++;
	}
	
	if ( isUppercaseInString(str) )
	{
		i++;
	}
	
	if ( isDigitInString(str) )
	{
		i++;
	}
	
	if ( isSpecialCharacterInString(str) )
	{
		i++;
	}
	if ( i >= 2 )
	{
		return true;
	}
	return false;
}

function LoadFrame()
{
	document.getElementById('PwdNotice').innerHTML = GetLanguageDesc("s1116");
	
	if (getCheckVal("Wizard_checkbox04_checkbox") == 1)
	{
		setDisable('Wizard_password04_01_text',0);
		setDisable('Wizard_password04_02_password',0);
		setDisable('Wizard_password04_03_password',0);
	}
	else
	{
		setDisable('Wizard_password04_01_text',1);
		setDisable('Wizard_password04_02_password',1);
		setDisable('Wizard_password04_03_password',1);
	}

	HideAll();
	
	if(IsInternetAvailable())
	{	
		setDisplay('wizard1', 1);
		setRadio('wizard1Mode',0);
	}
	else
	{
		NextStep1();
	}
	
	if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
		AlertEx("配置信息修改成功！");
	}
	
	ControlWanNameList();
	ControlWanLanBind();
	
	setDisable('Wizard_button5_1_button', 0);
	setDisable('Wizard_button5_2_button', 0);
	
	if (IsWlanAvailable())
    {
        var wlanEnbl = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.LANDevice.1.X_HW_WlanEnable);%>';

        setCheck('Wizard_checkbox02_checkbox', wlanEnbl);
        setDisplay('wlanconfig_detail',wlanEnbl);
    }
	
}

function isAscii(val)
{
    for ( var i = 0 ; i < val.length ; i++ )
    {
        var ch = val.charAt(i);
        if ( ch <= ' ' || ch > '~' )
        {
            return false;
        }
    }
    return true;
}

function CheckFormStep1()
{
	var UserName = getValue('Wizard_text01_text');
	var Password = getValue('Wizard_password01_password');
	var ModeVal = getRadioVal('wizard1Mode');
	if('0' == ModeVal)
	{
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
		if("Direct" == curEnterStyle)
		{
			if(false == GetFirstInternetWan())
			{
				AlertEx("没有已配置的拨号上网WAN。");
				return false;
			}
		}
		else
		{
			if('PPPoE' != GetCurrentInternetWan().EncapMode)
			{
				AlertEx("当前WAN不是PPPoE上网WAN。");
				return false;
			}
		}
	}
	else
	{
		if("Direct" == curEnterStyle)
		{
			if(false == GetFirstInternetWan())
			{
				AlertEx("没有已配置的拨号上网WAN。");
				return false;
			}
		}
		else
		{
			if('PPPoE' != GetCurrentInternetWan().EncapMode)
			{
				AlertEx("当前WAN不是PPPoE上网WAN。");
				return false;
			}
			if("INTERNET" != GetCurrentInternetWan().ServiceList)
			{
				AlertEx("不支持该类型WAN路由转桥接。");
				return false;
			}
		}
	}
}

function CheckForm()
{
	var oldPassword = document.getElementById("Wizard_password04_01_text");
	var newPassword = document.getElementById("Wizard_password04_02_password");
    var cfmPassword = document.getElementById("Wizard_password04_03_password");
	
	if (getCheckVal('Wizard_checkbox04_checkbox') == 0)
	{
		return true;
	}
	if (oldPassword.value == "")
	{
		AlertEx(GetLanguageDesc("s0f0f"));
		return false;
	}
	
	if (newPassword.value == "")
	{
		AlertEx(GetLanguageDesc("s0f02"));
		return false;
	}
	
	if (newPassword.value.length > 127)
	{
		AlertEx(GetLanguageDesc("s1904"));
		return false;
	}
	
	if (!isAscii(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s0f04"));
		return false;
	}
	
	if (cfmPassword.value != newPassword.value)
	{
		AlertEx(GetLanguageDesc("s0f06"));
		return false;
	}
	
	var NormalPwdInfo = FormatUrlEncode(oldPassword.value);
    var CheckResult = 0;

	$.ajax({
	type : "POST",
	async : false,
	cache : false,
	url : "../common/CheckNormalPwd.asp?&1=1",
	data :'NormalPwdInfo='+NormalPwdInfo, 
	success : function(data) {
		CheckResult=data;
		}
	});

	if (CheckResult != 1)
	{
		AlertEx(GetLanguageDesc("s0f11"));
		return false;
	}
	
	if(!CheckPwdIsComplex(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s1902"));
		return false;
	}
	
    setDisable('MdyPwdApply', 1);
    setDisable('MdyPwdcancel', 1);
	return true;
}


function GetLanguageDesc(Name)
{
    return CfgguideLgeDes[Name];
}

function ClickWizard_checkboxEnable()
{
	if (getCheckVal("Wizard_checkbox04_checkbox") == 1)
	{
		setDisable('Wizard_password04_01_text',0);
		setDisable('Wizard_password04_02_password',0);
		setDisable('Wizard_password04_03_password',0);
	}
	else
	{
		setDisable('Wizard_password04_01_text',1);
		setDisable('Wizard_password04_02_password',1);
		setDisable('Wizard_password04_03_password',1);
	}
	
}

function IsInternetAvailable()
{
	if(false == GetFirstInternetWan())
	{
		return false;
	}
	else
	{
		return true;
	}
}

function NextStep1()
{
	var PreStepID = "";
	
	if(true == IsInternetAvailable())
	{
		if(false == CheckFormStep1())
		{
			return false;
		}
	}
	HideAll();
	if(IsWlanAvailable())
	{
		setDisplay('wizard2',1);
		PreStepID = 'Wizard_button2_1_button';		
	}
	else
	{
		if(IsOtherWanAvailable())
		{
			setDisplay('wizard3',1);
			PreStepID = 'Wizard_button3_1_button';
		}
		else
		{
			setDisplay('wizard4',1);
			PreStepID = 'Wizard_button4_1_button';
		}
	}		
	
	if(false == IsInternetAvailable())
	{
		setDisplay(PreStepID, 0);
	}
}

function PreStep3()
{
	HideAll();
	if(IsWlanAvailable())
	{
		setDisplay('wizard2',1);
	}
	else
	{
		setDisplay('wizard1',1);
	}
}

function NextStep3()
{
	HideAll();
	setDisplay('wizard4',1);
}

function iTVAddPara(Form)
{
	
	if(parseInt(TopoInfo.EthNum,10) > 2)
	{
		Form.addParameter('z.Lan1Enable',getCheckVal('LAN1_checkbox'));
		Form.addParameter('z.Lan2Enable',getCheckVal('iTV_checkbox'));
		Form.addParameter('z.Lan3Enable',getCheckVal('LAN3_checkbox'));
		Form.addParameter('z.Lan4Enable',getCheckVal('LAN4_checkbox'));

	}
	else
	{
		Form.addParameter('z.Lan1Enable',getCheckVal('LAN1_checkbox'));
		Form.addParameter('z.Lan2Enable',getCheckVal('LAN2_checkbox'));	
	}
}
function InternetWanAddPara(Form)
{
	var UserName = getValue('Wizard_text01_text');
	var Password = getValue('Wizard_password01_password');
	var ModeVal = getRadioVal('wizard1Mode');
	if('0' == ModeVal)
	{
		if("Direct" == curEnterStyle)
		{
			curWandomain = GetFirstInternetWan().domain;
			if("IP_ROUTED" == GetFirstInternetWan().Mode.toString().toUpperCase())
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
		}
		else
		{
			curWandomain = GetCurrentInternetWan().domain;
			if("IP_ROUTED" == GetCurrentInternetWan().Mode.toString().toUpperCase())
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
		}
	}
	else
	{
		if("Direct" == curEnterStyle)
		{
			curWandomain = GetFirstInternetWan().domain;
			if("IP_ROUTED" == GetFirstInternetWan().Mode.toString().toUpperCase())
			{
				Form.addParameter('y.ConnectionType',"PPPoE_Bridged");
			}
			else
			{
				return "Ignore";
			}
		}
		else
		{
			curWandomain = GetCurrentInternetWan().domain;
			if("IP_ROUTED" == GetCurrentInternetWan().Mode.toString().toUpperCase())
			{
				Form.addParameter('y.ConnectionType',"PPPoE_Bridged");
			}
			else
			{
				return "Ignore";
			}
		}
	}
	
}

function ControlWanNameList()
{
	var Control = getElById("Wizardselect_select");
	var WanList = GetWanList();
	var WanListNew = new Array();
	var k =0;
	for(var j = 0; j < WanList.length; j++)
	{
		if(WanList[j].ServiceList.indexOf("OTHER") >= 0)
		{
			WanListNew[k++] = WanList[j];
		}
	}
    var i = 0;
    Control.options.length = 0;
	
    for (i = 0; i < WanListNew.length; i++)
    {    
        var Option = document.createElement("Option");
        Option.value = WanListNew[i].domain;
        Option.innerText = MakeWanName1(WanListNew[i]);
        Option.text = MakeWanName1(WanListNew[i]);
        Control.appendChild(Option);
    }
}

function ControlWanLanBind()
{
	var Control = getElById("Wizardselect_select");
	var WanList = GetWanList();
	var currentSelWan = "";
	var currentWanBind = new Array();
	var FindFlag = false;
	for(var i = 0; i < WanList.length; i++)
	{
		if(Control.value == WanList[i].domain)
		{
			currentSelWan = WanList[i].domain;
			break;
		}
	}
	currentSelWan += '.X_HW_LANBIND';
	if(currentSelWan.indexOf("WANPPP") >= 0)
	{
		for(var j = 0; j < wanppplanbind.length -1; j++)
		{
			if(currentSelWan == wanppplanbind[j].domain)
			{
				currentWanBind = wanppplanbind[j];
				FindFlag = true;
				break;
			}
			else
			{
				FindFlag = false;
			}
		}
	}
	else
	{
		for(var j = 0; j < waniplanbind.length -1; j++)
		{
			if(currentSelWan == waniplanbind[j].domain)
			{
				currentWanBind = waniplanbind[j];
				FindFlag = true;
				break;
			}
			else
			{
				FindFlag = false;
			}
		}
	}
	
	if(FindFlag == true)
	{
		if(parseInt(TopoInfo.EthNum,10)> 2)
		{
			setCheck('LAN1_checkbox',currentWanBind.lan1enable);
			setCheck('iTV_checkbox',currentWanBind.lan2enable);
			setCheck('LAN3_checkbox',currentWanBind.lan3enable);
			setCheck('LAN4_checkbox',currentWanBind.lan4enable);
		}
		else
		{
			setCheck('LAN1_checkbox',currentWanBind.lan1enable);
			setCheck('LAN2_checkbox',currentWanBind.lan2enable);
		}
	}	
}

function OnStep4()
{
	HideAll();
	if (true == IsOtherWanAvailable())
	{
		setDisplay('wizard3',1);
	}
	else
	{
		if(IsWlanAvailable())
		{
			setDisplay('wizard2',1);
		}
		else
		{
			setDisplay('wizard1',1);
		}
	}    
}
function NextStep4()
{
	if(!CheckForm())
	{
		HideAll();
		setDisplay('wizard4',1);
	}
	else
	{
		HideAll();
		setDisplay('wizard5',1);
		
		if (true == IsInternetAvailable())
		{
			setDisplay('internetinfo',1);
			document.getElementById('internet_mode').innerHTML= GetInternetMode();
			if(getRadioVal('wizard1Mode') == '0')
			{
				setDisplay('tr_internet_user',1);
				setDisplay('tr_internet_pwd',1);
				document.getElementById('internet_user').innerHTML= getValue('Wizard_text01_text');
				document.getElementById('internet_pwd').innerHTML= getValue('Wizard_password01_password');
			}
			else
			{
				setDisplay('tr_internet_user',0);
				setDisplay('tr_internet_pwd',0);
			}
		}
		
		if (true == IsWlanAvailable())
		{
			setDisplay('wlaninfo', 1);
            setDisplay('wlaninfo_detail', GetWlanCheck());
			document.getElementById('wlan_enable').innerHTML= GetWlanEnable();
			document.getElementById('wlan_ssid').innerHTML= getValue('Wizard_text02_text');
			document.getElementById('wlan_psk').innerHTML= getValue('Wizard_password02_password');
		}
		
		if(true == IsOtherWanAvailable())
		{
			setDisplay('iTVinfo', 1);			
			var iTVportHtml = "";
			document.getElementById('itv_enable').innerHTML= GetiTVEnable();
			if(parseInt(TopoInfo.EthNum,10)> 2)
			{
				if(getCheckVal('LAN1_checkbox') == '1')
				{
					iTVportHtml += "LAN1,";
				}
				if(getCheckVal('iTV_checkbox') == '1')
				{
					iTVportHtml += "iTV,";
				}
				if(getCheckVal('LAN3_checkbox') == '1')
				{
					iTVportHtml += "LAN3,";
				}
				if(getCheckVal('LAN4_checkbox') == '1')
				{
					iTVportHtml += "LAN4,";
				}
				
			}
			else
			{
				if(getCheckVal('LAN1_checkbox') == '1')
				{
					iTVportHtml += "LAN1,";
				}
				if(getCheckVal('LAN2_checkbox') == '1')
				{
					iTVportHtml += "LAN2,";
				}
			}
			iTVportHtml = iTVportHtml.substring(0, iTVportHtml.length - 1);
			document.getElementById('itv_port').innerHTML= iTVportHtml;
		}
	}
	
	
}
function OnStep5()
{
	HideAll();
    setDisplay('wizard4',1);
}
function OnfinishStep()
{
	var Form = new webSubmitForm();
	
	setDisable('Wizard_button5_1_button', 1);
	setDisable('Wizard_button5_2_button', 1);

	var url = 'set.cgi?';

	if((true == IsInternetAvailable()) && ("Ignore" != InternetWanAddPara(Form)))
	{
		url +='&y='+curWandomain;
	}
	if ((true == IsWlanAvailable()) && (null != Wlan))
	{
		WlanAddFormPara(Form);
        if (GetWlanCheck())
        {
            url += '&p=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1' + '&q=InternetGatewayDevice.LANDevice.1.WLANConfiguration.1.PreSharedKey.1'
        }
		url +='&o=InternetGatewayDevice.LANDevice.1';
	}
	
	if(true == IsOtherWanAvailable())
	{	
		var Control = getElById("Wizardselect_select");
		iTVAddPara(Form);
		url += '&z='+Control.value+'.X_HW_LANBIND';
	}
	
	if (getCheckVal("Wizard_checkbox04_checkbox") == 1)
	{
		Form.addParameter('x.Password',getValue('Wizard_password04_02_password'));	
		Form.addParameter('x.OldPassword',getValue('Wizard_password04_01_text'));	
		url += '&x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1';
	}
	
	url += '&RequestFile=html/ssmp/cfgguide/cfgwizard.asp';
	Form.setAction(url);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">

<div id="wizard1" style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="wizard1_title">
  	<tr>
		<td class="table_head" width="100%">
		<label id="Title_wizard1_lable">请选择您的上网方式</label>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
		<td class="height_15px">
			<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
		</td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" id="wizard1_table1"> 
	<tr><td>
		<input name="wizard1Mode" id="Wizard_radio01_radio" type="radio" value="1" onclick="radioChooseMode();"/> 
				<script>document.write("桥接方式，PC自己拨号获取IP上网");</script>
	 </td></tr>
	<tr><td>
		<input name="wizard1Mode" id="Wizard_radio02_radio" type="radio" value="0" onclick="radioChooseMode();"/> 
				<script>document.write("路由方式，网关自动拨号方式上网");</script>
	 </td></tr>       	 
</table> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
		<td class="height_15px"></td>
	</tr>
</table> 

<table width="100%" border="0" cellpadding="0" cellspacing="0" id="Wizard1Panel" > 
	<tr>
	<td class="table_left width_25p">上网账号</td> 
	<td class="table_right width_75p"> <input type="text" id="Wizard_text01_text" maxlength="63"> </td> 
  </tr>
  <tr>
	<td class="table_left width_25p" >上网密码</td> 
	<td class="table_right width_75p"> <input type="password" id="Wizard_password01_password" maxlength="63" > </td> 
  </tr>              
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="wizard1_table2"> 
  <tr align="right"> 
	<td class="table_submit">
	 <input id="Wizard_button1_2_button" type="button" onClick="NextStep1();"  value="下一步"> 
	<td>
  </tr>         
</table>

</div>

<div id="wizard2" style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<tr>
		<td class="table_head" width="100%">
		<label id="Title_wizard2_lable">请输入无线宽带配置</label>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
		<td class="height_15px"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="table_left"  width="25%">
			<input checked type='checkbox' id='Wizard_checkbox02_checkbox' name='Wizard_checkbox02_checkbox' onClick='SetWlanEnable();' value="OFF">
		</td>

		<td class="table_right" width="75%">		
			无线网络启用
		</td>
	</tr>
</table>
<table id="wlanconfig_detail" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="table_left"  width="25%">无线名称:&nbsp;</td>
		<td class="table_right" width="75%">
		<input type="text" name="Wizard_text02_text" id="Wizard_text02_text" style="width:123px" maxlength="32">
			<font class="color_red">*</font><span class="gray">
			<script>document.write(cfg_wlancfgdetail_language['amp_linkname_note']);</script></span>
		</td>
	</tr>
	
	<tr>
		<td class="table_left"  width="25%">密钥:&nbsp;</td>
		<td class="table_right" width="75%">
		<input type='password' id='Wizard_password02_password' name='Wizard_password02_password' style="width:123px" maxlength='64' class="amp_font"  onchange="" />
			<font class="color_red">*</font><span class="gray">
			<script>document.write(cfg_wlancfgdetail_language['amp_wpa_psknote']);</script></span>
		</td>
	</tr>
	<tr>
	<td height="40"></td>
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
	var ssid;
    ssid = ltrim(getValue('Wizard_text02_text'));
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

	if(0 != ssid.indexOf("ChinaNet-"))
	{
		AlertEx("无线名称必须以 ChinaNet- 开头。");
		return false;
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
    if(GetWlanCheck())
    {
        if (false == CheckSsid())
    	{
    		return;
    	}
	
	    if (false == CheckPsk())
    	{
    		return;
    	}
    }

	HideAll();
	if (true == IsOtherWanAvailable())
	{
		setDisplay('wizard3',1);
	}
	else
	{
		setDisplay('wizard4',1);
	}
}

function SetWlanEnable()
{
    var enable = GetWlanCheck();

    setDisplay('wlanconfig_detail',enable);
}

</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr align="right">
		<td class="table_submit">
		<input name="Wizard_button2_1_button" id="Wizard_button2_1_button" type="button" onClick="WlanPrevious();"  value="上一步"> 
      	<input name="Wizard_button2_2_button" id="Wizard_button2_2_button" type="button" onClick="WlanNext();"  value="下一步"> 
		</td>
	</tr>
</table>
</div>

<div id="wizard3" style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0" id="wizard3_title">
  	<tr>
		<td class="table_head" width="100%">
		<label id="Title_wizard2_lable">请输入iTV配置</label>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr >
		<td class="height_15px"></td>
	</tr>
</table>

<table width="100%" border="0" cellpadding="0" cellspacing="0" id="wizard3_table1"> 
<tr>
	<td class="table_left width_25p">选择iTV的接口</td> 
	<td class="table_right width_75p"> <select id="Wizardselect_select" class="Select"> </select></td> 
</tr> 
</table>
<script language="JavaScript" type="text/javascript">
var Control = getElById("Wizardselect_select");
Control.onchange = function()
{
	ControlWanLanBind();
}
</script>
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="wizard3_table2"> 
	
	<tr>
	<td class="table_left"  width="25%"></td>
	<td id="td_LAN1_checkbox">
		<input name="LanPort" id="LAN1_checkbox" type="checkbox" value="LAN1" onclick=""/> 
				<script>document.write("网口1");</script>
	 </td>
	 <td id="td_iTV_checkbox">
		<input name="LanPort" id="iTV_checkbox" type="checkbox" value="LAN2" onclick=""/> 
				<script>document.write("iTV");</script>
	 </td>
	 <td id="td_LAN2_checkbox">
		<input name="LanPort" id="LAN2_checkbox" type="checkbox" value="LAN2" onclick=""/> 
				<script>document.write("网口2");</script>
	 </td>
	 <td id="td_LAN3_checkbox">
		<input name="LanPort" id="LAN3_checkbox" type="checkbox" value="LAN3" onclick=""/> 
				<script>document.write("网口3");</script>
	 </td>
	 <td id="td_LAN4_checkbox">
		<input name="LanPort" id="LAN4_checkbox" type="checkbox" value="LAN4" onclick=""/> 
				<script>document.write("网口4");</script>
	 </td>
	 </tr>        	 
</table> 
<script language="JavaScript" type="text/javascript">
	setDisplay('td_iTV_checkbox',0);
	setDisplay('td_LAN2_checkbox',0);
	setDisplay('td_LAN3_checkbox',0);
	setDisplay('td_LAN4_checkbox',0);
	if(parseInt(TopoInfo.EthNum,10) > 2)
	{
		setDisplay('td_iTV_checkbox',1);
		setDisplay('td_LAN3_checkbox',1);
		setDisplay('td_LAN4_checkbox',1);
	}
	else
	{
		setDisplay('td_LAN2_checkbox',1);
	}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button" id="wizard3_table3"> 
  <tr>
    <td align="right"> 
	  <input  name="Wizard_button3_1_button" id="Wizard_button3_1_button" type="button" onClick="PreStep3();"  value="上一步"> 
      <input  name="Wizard_button3_2_button" id="Wizard_button3_2_button" type="button" onClick="NextStep3();"  value="下一步"> 
	</td> 
  </tr>         
</table>

</div>

<div id="wizard4" style="display:none"> 
<table id="table_changepassword" width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td class="table_head" width="100%"><label id = "Title_wizard4_lable">终端登陆密码修改</label></td> 
</tr>
<tr>
<td class="height_15px"></td> 
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="table_left"  width="25%">
		<input id='Wizard_checkbox04_checkbox' name='Wizard_checkbox04_checkbox' type='checkbox' onclick='ClickWizard_checkboxEnable()'>  
		</td>
		<td class="table_right" width="75%">		
		终端登陆密码修改
		</td>
	</tr>
	<tr>
		<td class="table_left" width="25%">旧密码：</td>
		<td class="table_right" rowspan="3" width="75%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="table_right" width="27%">
						<input name='Wizard_password04_01_text' type="password" id="Wizard_password04_01_text" size="15">
					</td>
					<td rowspan="3" class="table_right" width="73%" id='PwdNotice' style='background:#edeef0;'>
					</td>
				</tr>
				<tr>
					<td class="table_right" width="27%">
						<input name='Wizard_password04_02_password' type="password" id="Wizard_password04_02_password" size="15">
					</td>	
				</tr>
				<tr>
					<td class="table_right" width="27%">
						<input name='Wizard_password04_03_password' type='password' id="Wizard_password04_03_password" size="15">
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="table_left" width="25%">新密码：</td>
		</td>				
	</tr>
	
	<tr>
		<td class="table_left" width="25%">新密码确认：</td>
	</tr>
</table>
<table width="100%" height="40" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
  <td>
  </td> 
  </tr> 
</table> 
<table width="100%" border="0" cellspacing="1" cellpadding="0" > 
  <tr> 
    <td align="right"> 
	  <input name="MdyPwdApply" id="Wizard_button4_1_button" type="button" onClick="OnStep4();"  value="上一步"> 
      <input name="MdyPwdcancel" id="Wizard_button4_2_button" type="button" onClick="NextStep4();"  value="下一步"> 
	</td> 
  </tr> 
</table> 
</div>
<div id="wizard5" style="display:none">
<table id="table_cfginfo" width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
<td class="table_head" width="100%"><label id="Title_wizard5_lable">配置信息确认</label></td> 
</tr>
<tr>
<td class="height_15px"></td>
</tr> 
</table>

<table id="internetinfo" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
	<tr> 
	<td class="table_left" width="25%">拨号类型：</td>
	<td class="table_right" width="75%" id="internet_mode"></td>
	</tr>
	<tr id="tr_internet_user"> 
	<td class="table_left" width="25%">上网账号：</td>
	<td class="table_right" width="75%" id="internet_user"></td>
	</tr>
	<tr id="tr_internet_pwd"> 
	<td class="table_left" width="25%">上网密码：</td>
	<td class="table_right" width="75%" id="internet_pwd"></td>
	</tr>
</table>

<table id="wlaninfo" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
	<tr> 
	<td class="table_left" width="25%">无线状态：</td>
	<td class="table_right" width="75%" id="wlan_enable"></td>
	</tr>
</table>
<table id="wlaninfo_detail" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
	<tr > 
	<td class="table_left" width="25%">无线名称：</td>
	<td class="table_right" width="75%" id="wlan_ssid"></td>
	</tr>
	<tr > 
	<td class="table_left" width="25%">无线密钥：</td>
	<td class="table_right" width="75%" id="wlan_psk"></td>
	</tr>
</table>

<table id="iTVinfo" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none">
	<tr> 
	<td class="table_left" width="25%">iTV状态：</td>
	<td class="table_right" width="75%" id="itv_enable"></td>
	</tr>
	<tr > 
	<td class="table_left" width="25%">iTV端口：</td>
	<td class="table_right" width="75%" id="itv_port"></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="0" >
<tr>
<td height="40"></td>
</tr>  
  <tr> 
    <td align="right">
	  <input  name="MdyPwdApply" id="Wizard_button5_1_button" type="button" onClick="OnStep5();" value="上一步"> 
      <input  name="MdyPwdcancel" id="Wizard_button5_2_button" type="button" onClick="OnfinishStep();"  value="完成"> 
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
