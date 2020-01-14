<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<script type="text/javascript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<title>ONT Authentication</title>
<script language="JavaScript" type="text/javascript">

var gponpassword;
var hexgponpassword;

function WebCtl(domain ,temp)
{
	this.domain = domain;
    this.temp = temp;	
}

var WebScenarioCtl =<%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.AclServices,WebPermanentCloseControl,WebCtl);%>;
var scenarioMode = WebScenarioCtl[0];
function stDevInfo(domain, hexpassword)
{
    this.domain = domain;
	this.hexpassword = hexpassword;
	hexgponpassword = hexpassword;
	gponpassword = ChangeHextoAscii(hexpassword);
}

var stDevInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo, X_HW_PonHexPassword, stDevInfo);%>;
var stDevinfo = stDevInfos[0];

var stOnlineStatusInfo = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_DEBUG.AMP.OntOnlineStatus.ontonlinestatus);%>;
var isOntOnline = stOnlineStatusInfo;

var DtFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_DT);%>';
var StarhubncFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_STARHUBNC);%>';
var NCFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_NC);%>';
var AtTelecomFlag = '<%HW_WEB_GetFeatureSupport(HW_AMP_FEATURE_TELECOM);%>';

function ShowOrHideText(checkBoxId, passwordId,textId, value)
{
    if (1 == getCheckVal(checkBoxId))
	{
	      setDisplay(passwordId, 1);
	      setDisplay(textId, 0);	     
	}
	else
	{
	      setDisplay(passwordId, 0);
	      setDisplay(textId, 1);
	}
}

function CheckStr(strField, strCheckStr, uiMinLen, uiMaxLen)
{
    var ret = true;
    var strTmp = "";
    
	if (('' == strCheckStr || strCheckStr == null) && (uiMinLen > 0))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chklen1'] + uiMinLen + cfg_ontauth_language['amp_auth_chklen2'] + uiMaxLen + cfg_ontauth_language['amp_auth_chklen3'];
        AlertEx(strTmp);
        return false;
    }

    if(false == isSafeStringExc(strCheckStr,''))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chk6'] + strCheckStr + cfg_ontauth_language['amp_auth_chk7'] + cfg_ontauth_language['amp_auth_chk5'];
        AlertEx(strTmp);
        return false;	
    }
	
    if ((uiMaxLen < strCheckStr.length) || (uiMinLen > strCheckStr.length))
    {
        strTmp = "";
        strTmp = strField + cfg_ontauth_language['amp_auth_chklen1'] + uiMinLen + cfg_ontauth_language['amp_auth_chklen2'] + uiMaxLen + cfg_ontauth_language['amp_auth_chklen3'];
        AlertEx(strTmp);
        return false;
    }   
	
      return ret;
}

function CheckForm(type)
{
    var ret = false;

    with (getElById ("ConfigForm"))
	{
		if (0 == getSelectVal('Passwordmode'))
		{
			var gponpwd = getValue('PwdGponValue');
			
			ret = CheckStr(cfg_ontauth_language['amp_passwd_str'], gponpwd, 0, 10);
			if (false == ret)
			{
				return ret;
			}
		}
		else if (1 == getSelectVal('Passwordmode'))
		{
			var gponpwd = getValue('HexPwdValue');
			
			return CheckHexPassWord();
		}
   }

    return ret;
}

function OnChangeMode1()
{
	if(0 == getSelectVal('Passwordmode'))
	{
		setDisplay("TrPasswordGpon",1);
		setDisplay("TrHexPassword",0);		
		getElById("PwdGponValue").value = gponpassword;
		getElById("tPwdGponValue").value = gponpassword;
		top.Passwordmode=0;
	}
	else if(1 == getSelectVal('Passwordmode'))
	{
		setDisplay("TrPasswordGpon",0);
		setDisplay("TrHexPassword",1);
		setText('HexPwdValue', hexgponpassword);
		setText('tHexPwdValue', hexgponpassword);
		top.Passwordmode=1;
	}
}

function ChangeHextoAscii(hexpasswd)
{
    var str;
	var len = 0;
	
	len = hexpasswd.length;

	if (0 != len%2)
	{
	    hexpasswd += "0";
	}
	
    str = hexpasswd.replace(/[a-f\d]{2}/ig, function(m){
    return String.fromCharCode(parseInt(m, 16));});

    return str;
}

function ChangeAsciitoHex(passwd)
{
    var hexstr = "";
	var temp = "";
	var code = 0;
	for (var i = 0; i < passwd.length; i++)
	{
	     code = parseInt(passwd.charCodeAt(i));
		 if (code < 16)
		 {
		     hexstr += "0";
			 hexstr += code.toString(16);
		 } 
		 else
		 {
		     hexstr += code.toString(16);
		 }
	}
	
	return hexstr;	
}

function CheckHexPassWord()
{
	var ret = true;
    var len = 0;
	var i;
	var temp1 = 0;
	var temp2 = 0;
	with (getElById('ConfigForm'))
	{		
		var hexpassword = getValue('HexPwdValue');
		
		len = hexpassword.length;
		
		if (20 < hexpassword.length)
		{
			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk1']);
		    return false;
		}
	
		if (0 != len%2)
		{
			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk1']);
			return false;
		}

  
		if (isHexaNumber(hexpassword) == false)
		{
			AlertEx(cfg_ontauth_language['amp_hexpaswd_chk2']);
			return false;
		}

	}
	return ret;
}

function AddSubmitParam(SubmitForm, type)
{
	getOntOnlineStatus();
	if  (isOntOnline == 1)
	{
		AlertEx(cfg_ontauth_language['amp_ontauth_protectPwdLoidKey']);
		return;
	}

    SubmitForm.addParameter('x.X_HW_PonHexPassword', hexgponpassword);

	SubmitForm.addParameter('x.X_HW_ForceSet', 1);

	if (1 == DtFlag)
	{
		SubmitForm.setAction('set.cgi?' +'x=InternetGatewayDevice.DeviceInfo' 
							+ '&y=InternetGatewayDevice.X_HW_Security.AclServices' 
							+ '&RequestFile=html/amp/ontauth/passworduser.asp');
		SubmitForm.addParameter('y.WebPermanentCloseControl',getRadioVal('scenario'));
    }
	else
	{
		SubmitForm.setAction('set.cgi?' +'x=InternetGatewayDevice.DeviceInfo' 
							+ '&RequestFile=html/amp/ontauth/passworduser.asp');
	}
	
    setDisable('btnApply_ex2',1);
    setDisable('cancelValue2',1);
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
    SubmitForm.submit();
}

function isHexaNumber(number)
{
    for (var index = 0; index < number.length; index++)
    {
        if (isHexaDigit(number.charAt(index)) == false)
        {
            return false;
        }
    }
    return true;
}

function init()
{
    protectPwdLoidKey();

    password = ChangeHextoAscii(stDevinfo.hexpassword);
	getElById("PwdGponValue").value = password;
	getElById("tPwdGponValue").value = password;
	setText('HexPwdValue', stDevinfo.hexpassword);
	setText('tHexPwdValue', stDevinfo.hexpassword);
	
	if (1 != DtFlag)
	{
		setDisplay("TrScenario",0);
	}

	if ((1 == NCFlag) || (1 == StarhubncFlag))
	{
		setDisable("Passwordmode",1);
		setDisable("hidePwdGponValue",1);
		setDisable("hideHexPwdValue",1);
	}

    if (1 == AtTelecomFlag)
    {
        setDisable("Passwordmode", 1);
        setDisable("hidePwdGponValue", 1);
        setDisable("hideHexPwdValue", 1);

        setDisable('PwdGponValue', 1);
        setDisable('tPwdGponValue', 1);
        setDisable('HexPwdValue', 1);
        setDisable('tHexPwdValue', 1);
        setDisable('btnApply_ex2', 1);
        setDisable('cancelValue2', 1);
    }
}

function CancelConfig()
{
    init();
}

function protectPwdLoidKey()
{
	getOntOnlineStatus();
    if (isOntOnline == 1)
    {
        setDisable('PwdGponValue', 1);
        setDisable('tPwdGponValue', 1);
        setDisable('HexPwdValue', 1);
        setDisable('tHexPwdValue', 1);
        setDisable('btnApply_ex2', 1);
        setDisable('cancelValue2', 1);
    }
    else
    {
        setDisable('PwdGponValue', 0);
        setDisable('tPwdGponValue', 0);
        setDisable('HexPwdValue', 0);
        setDisable('tHexPwdValue', 0);
        setDisable('btnApply_ex2', 0);
        setDisable('cancelValue2', 0);
    }
}

function refreshPasswordMode()
{
	if (top.Passwordmode == 0)
	{
	  setSelect('Passwordmode', 0);
	  setDisplay("TrPasswordGpon", 1);
      setDisplay("TrHexPassword",0);
	}
	else
	{
	  setSelect('Passwordmode', 1);
	  setDisplay("TrPasswordGpon", 0);
      setDisplay("TrHexPassword", 1);
	}
}

function getOntOnlineStatus()
{
  $.ajax({
            type : "POST",
            async : false,
            cache : false,
            url : "ontOnlineStatus.asp",
            success : function(data) {
               	isOntOnline = data;
            }
        });
}

function LoadFrame()
{
	refreshPasswordMode();
	
	init();
	
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = cfg_ontauth_language[b.getAttribute("BindText")];
	}	
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="title_common" BindText='amp_auth_title'><div id="DivPageTips"></div></td>
        </tr>
      </table></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr > 
    <td class="height5p"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td> <form id="ConfigForm" action="">
        <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
		<tr id="TrScenario">
			<td class="table_title width_per20" BindText='amp_scenario_select'></td>
			<span class="gray"> &nbsp;
			  <td class="table_right"> <input name="scenario" id="scenario" type="radio" value="1" onclick=""/> 
			  <script>document.write(cfg_ontauth_language['amp_scenario_lab']);</script></td>
			  <td class="table_right"> <input name="scenario" id="scenario" type="radio" value="2"  checked="checked" onclick=""/> 
			  <script>document.write(cfg_ontauth_language['amp_scenario_field']);</script></td>
			  <script>			
			  if (scenarioMode.temp == 1)
			  {
				  setRadio('scenario',1);
			  }
			  else
			  {
				  setRadio('scenario',2);
			  }
			  </script></span>
	      </tr>          
          <tr id="TrPasswordmode"> 
            <td class="table_title width_per20" BindText='amp_passwd_mode'></td>
            <td colspan="2" class="table_right"> <select name="Passwordmode" size="1" id="Passwordmode" onChange="OnChangeMode1()">
                <option value="0" selected="selected"><script>document.write(cfg_ontauth_language['amp_char_mode']);</script></option>
                <option value="1"><script>document.write(cfg_ontauth_language['amp_hex_mode']);</script></option>
              </select></td>
          </tr>          
          <tr id="TrPasswordGpon"> 
            <td class="table_title width_per20" BindText='amp_pass_word'></td>
            <td colspan="2" class="table_right"> <input name="PwdGponValue" type="password" id="PwdGponValue" maxlength="10" onchange="gponpassword=getValue('PwdGponValue'); getElById('tPwdGponValue').value = gponpassword;hexgponpassword = ChangeAsciitoHex(gponpassword); getElById('tHexPwdValue').value = hexgponpassword; getElById('HexPwdValue').value = hexgponpassword;"/>
			<input name="tPwdGponValue" type="text" id="tPwdGponValue" maxlength="10" style="display:none" onchange="gponpassword=getValue('tPwdGponValue');getElById('PwdGponValue').value = gponpassword;hexgponpassword = ChangeAsciitoHex(gponpassword);getElById('tHexPwdValue').value = hexgponpassword;getElById('HexPwdValue').value = hexgponpassword;"/>
			<input checked type="checkbox" id="hidePwdGponValue" name="hidePwdGponValue" value="on" onClick="ShowOrHideText('hidePwdGponValue', 'PwdGponValue', 'tPwdGponValue', gponpassword);"/>
            <script>document.write(cfg_ontauth_language['amp_password_hide']);</script>
			<span class="gray"><script>document.write(cfg_ontauth_language['amp_passwd_note2']);</script></span> 
			</td>
          </tr>
          <tr id="TrHexPassword"> 
            <td class="table_title width_per20" BindText='amp_pass_word'></td>
            <td colspan="2" class="table_right"> <input name="HexPwdValue" type="password" id="HexPwdValue" maxlength="20" onchange="hexgponpassword=getValue('HexPwdValue');getElById('tHexPwdValue').value = hexgponpassword;gponpassword = ChangeHextoAscii(hexgponpassword);getElById('PwdGponValue').value = gponpassword;getElById('tPwdGponValue').value = gponpassword;"/>
			<input name="tHexPwdValue" type="text" id="tHexPwdValue" maxlength="20"  style="display:none" onchange="hexgponpassword=getValue('tHexPwdValue');getElById('HexPwdValue').value = hexgponpassword;gponpassword = ChangeHextoAscii(hexgponpassword);getElById('PwdGponValue').value = gponpassword;getElById('tPwdGponValue').value = gponpassword;"/>
			<input checked type="checkbox" id="hideHexPwdValue" name="hideHexPwdValue" value="on" onClick="ShowOrHideText('hideHexPwdValue', 'HexPwdValue', 'tHexPwdValue', hexgponpassword);"/>
            <script>document.write(cfg_ontauth_language['amp_password_hide']);</script>
			<span class="gray"><script>document.write(cfg_ontauth_language['amp_passwd_note3']);</script></span> 
			</td>
          </tr>          
        </table>
        <table id="TblApplySN" width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
            <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
                <tr > 
                  <td class="table_submit width_per20"></td>
                  <td class="table_submit width_per80"> 
				  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
				  <button name="btnApply_ex2" id="btnApply_ex2" type="button" class="submit" onClick="Submit();"><script>document.write(cfg_ontauth_language['amp_ontauth_apply']);</script></button>
                    <button name="cancelValue2" id="cancelValue2" type="button" class="submit" onClick="CancelConfig();"><script>document.write(cfg_ontauth_language['amp_ontauth_cancel']);</script></button>
                  </td>
                </tr>
              </table></td>
          </tr>
        </table>
      </form></td>
  </tr>
</table>
</body>
</html>
