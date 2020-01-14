<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function stAuthGetLoidPwd(domain,Loid,Password)
{
    this.domain   = domain;
    this.Loid     = Loid;
    this.Password = Password;
}

var MngtGdct = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_GDCT);%>';

var AuthInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, UserName|UserId, stAuthGetLoidPwd);%>; 

var simcardstatus = '<%webAspGetSimRegStatus();%>';

var LoidPwdInfo = AuthInfo[0];
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

var CfgFtWordArea = '<%GetConfigAreaInfo();%>';

function SetCookie(name, value)
{
	var expdate = new Date();
	var argv = SetCookie.arguments;
	var argc = SetCookie.arguments.length;
	var expires = (argc > 2) ? argv[2] : null;
	
	var path = "/";
	var domain = (argc > 4) ? argv[4] : null;
	var secure = (argc > 5) ? argv[5] : false;
	if(expires!=null) expdate.setTime(expdate.getTime() + ( expires * 1000 ));
	document.cookie = name + "=" + escape (value) +((expires == null) ? "" : ("; expires="+ expdate.toGMTString()))
	+((path == null) ? "" : ("; path=" + path)) +((domain == null) ? "" : ("; domain=" + domain))
	+((secure == true) ? "; secure" : "");
} 

function GetCookieVal(offset)
{
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1)
	endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr));
}

function GetCookie(name)
{
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen)
	{
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg)
			return GetCookieVal(j);
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0) break;
	}
	return null;
}

function loidconfig()
{
	
	
	var StepStatus = GetCookie('StepStatus');
	if (StepStatus == null || StepStatus == "" || (StepStatus < '0' || StepStatus > '7'))
	{
		var PrevTime = new Date();
		SetCookie("lStartTime",PrevTime);
		SetCookie("StepStatus","0");
		SetCookie("CheckOnline","0");
		SetCookie("lastPercent","0");	
	}
	
    window.location="/loidresult.asp";
	return;		
}
function LoadFrame()
{
	if( 1 == simcardstatus )
	{
		document.getElementById("DivAuthentication").style.display = "none";
		document.getElementById("DivSimcard").style.display = "";
	}
	else
	{
		if(CfgFtWordArea.toUpperCase() != 'NOCHOOSE' && CfgFtWordArea.toUpperCase() != 'CHOOSE' )
		{
			document.getElementById("DivAuthentication").style.display = "";
		}
		else if(CfgFtWordArea.toUpperCase() == 'NOCHOOSE')
		{	
			document.getElementById("DivAuthentication").style.display = "";		
		}
		else
		{
			window.parent.document.location.href = "/loidreg.asp";
			return;
		}

		if (curUserType != sysUserType )
		{
			setDisable("LoidId_text",1);
			setDisable("Pwd_password",1);
			setDisable("setbutton",1);
		}

		setText("LoidId_text", LoidPwdInfo.Loid);	
		if (MngtGdct != 1)
		{
			setText("Pwd_password", LoidPwdInfo.Password);
		}

		if( LoidPwdInfo.Password != "" )
		{
			setCheck('Loidpwd_checkbox',1);
			setDisplay('Trshowloidpassword',1);	
		}
		else
		{
			setCheck('Loidpwd_checkbox',0);
			setDisplay('Trshowloidpassword',0);	
		}
	
	}

}

function CheckForm()
{
    var username = document.getElementById("LoidId_text");
    var userid = document.getElementById("Pwd_password");
	
	if (username.value == "")
	{
		AlertEx("LOID不能为空。");
		return false;
	}
	
	if (isValidAscii(username.value) != '')
	{
		AlertEx("LOID包含非ASCII字符，请输入正确的LOID。");
		return false;
	}

	if (username.value.length > 24)
	{
		AlertEx("LOID的长度必须在1~24个字符之间。");
		return false;
	}
	
	if (userid.value != "")
	{
		if (isValidAscii(userid.value) != '')
		{
			AlertEx("Password包含非ASCII字符，请输入正确的Password。");
			return false;
		}
		
		if (userid.value.length > 12)
		{
			AlertEx("Password的长度必须在1~12个字符之间。");
			return false;
		}
	}

    setDisable('setbutton', 1);
	return true;
}

function AddSubmitParam(SubmitForm,type)
{
	SubmitForm.addParameter('x.UserName',getValue('LoidId_text'));	
	SubmitForm.addParameter('x.UserId',getValue('Pwd_password'));

	SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.X_HW_UserInfo'
							 + '&RequestFile=html/ssmp/loid/loid.asp');	 
}

function ClickLoidpwdEnable()
{
	if (getCheckVal("Loidpwd_checkbox") == 1)
	{
		setDisplay('Trshowloidpassword',1);	
	}
	else
	{
		setDisplay('Trshowloidpassword',0);	
	}
}

function CancelValue()
{
	setText("LoidId_text", LoidPwdInfo.Loid);

    if (MngtGdct != 1)
    {
        setText("Pwd_password", LoidPwdInfo.Password);
    }
    else
    {
        setText("Pwd_password", "");
    }
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div id="DivSimcard" style="display:none"> 
<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_01" id="text_tips" style="padding-left:10px;" width="100%">在本页面上，您可以通过点击 “业务配置” 按钮查看设备注册状态。</td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td align="right"> <input class="submit" name="btnloidconfig" id="btnloidconfig" type='button' onClick='loidconfig()' value="业务配置"> 
	  </td> 
    </tr> 
  </table> 
</div> 
<div name="DivAuthentication" id="DivAuthentication"  style="display:none">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<label id="Loid_lableL" > 
<tr> 
<td class="table_head" width="100%">逻辑ID设置 </td> 
</tr>
<tr> 
	<td height="5"></td> 
</tr>		  
<tr> 
	<td class="title_01"  style="padding-left:10px;" width="100%"><lable>逻辑ID功能用于新设备的注册及下发，请不要更改，如果修改逻辑ID导致业务不正常，请重启网关。</lable> </td> 
</tr>
</label> 
</table>

<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table>
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
   <td class="title_01"  align="left" width='20%'>逻辑ID认证是否使用密码</td> 
    <td class="table_right"   align="left" colspan="6" width='75%'>
    <input id='Loidpwd_checkbox' name='Loidpwd_checkbox'  type='checkbox' onclick='ClickLoidpwdEnable()'> 
    </td> 
  </tr> 
</table> 
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_bg"> 
  <tr id="TroldPassword"> 
    <td  class="table_title" align="left" width='25%'>逻辑ID:</td> 
    <td  class="table_right" align="left" colspan="6" width='75%'>
    	<input name='LoidId_text' type="text" id="LoidId_text" maxlength="24"> 
      <strong style="color:#FF0033">*</strong>
      <span class="gray"><script>document.write("(字符串最多包含24个英文字符或数字)");</script></span>
      </td> 
  </tr>  
</table>
<div id ="Trshowloidpassword" style="display:none"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_bg"> 
  <tr> 
    <td class="table_title"  align="left" width='25%'>逻辑密码:</td> 
    <td class="table_right"   align="left" colspan="6" width='75%'>
    	 <input name='Pwd_password' type="text" id="Pwd_password" maxlength="12">
    	 <span class="gray"><script>document.write("(字符串最多包含12个英文字符或数字)");</script></span>
    </td>
  </tr> 
</table>
 </div>  
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button"> 
  <tr> 
    <td class="table_submit" width='25%'></td> 
    <td  class="table_submit" align="right">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">	
	<input  class="submit" name="setbutton" id="Apply_button" type="button" onClick="Submit();" value="保存/应用"> 
  </tr> 
</table> 
<table width="100%" height="15" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
</div>	
</body>
</html>
