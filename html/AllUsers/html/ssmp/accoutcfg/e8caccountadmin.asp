<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
function GetLanguageDesc(Name)
{
    return AccountLgeDes[Name];
}

function stModifyUserInfo(domain,UserName,UserLevel)
{
    this.domain = domain;
 	this.UserName = UserName;
    this.UserLevel = UserLevel;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel, stModifyUserInfo);%>;  

for(var i = 0; i < stModifyUserInfos.length - 1; i++)
{
	if(stModifyUserInfos[i].UserLevel == 1 )
	{
		sptUserName = stModifyUserInfos[i].UserName;
	}
}

function CheckPwdIsComplex(str)
{
	var i = 0;
	if ( 6 > str.length )
	{
		return false;
	}
	
	if (!CompareString(str,sptUserName) )
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
	
	if ( isSpecialCharacterNoSpace(str) )
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
	if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
	    AlertEx(GetLanguageDesc("s0f01"));
	}
}

function isValidAscii(val)
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

function CheckParameter()
{

    var newPassword = document.getElementById("PwdNew_password");
    var cfmPassword = document.getElementById("PwdCfm_password");

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

	if (!isValidAscii(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s0f04"));
		return false;
	}
	
	if (cfmPassword.value != newPassword.value)
	{
		AlertEx(GetLanguageDesc("s0f06"));
		return false;
	}
	
	if(!CheckPwdIsComplex(newPassword.value))
	{
		AlertEx(GetLanguageDesc("s1902"));
		return false;
	}
	
    setDisable('Pwdptnsave_button', 1);
	

	return true;
}

function SubmitPwd()
{
	if(!CheckParameter())
	{
		return false;
	}
	var Form = new webSubmitForm();
    Form.addParameter('x.Password',getValue('PwdNew_password'));	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
    Form.setAction('set.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.1'
						 + '&RequestFile=html/ssmp/accoutcfg/e8caccountadmin.asp');	
	Form.submit();				 
}

function GetLanguageDesc(Name)
{
    return AccountLgeDes[Name];
}

function CancelValue()
{
    setText('PwdNew_password','');
    setText('PwdCfm_password','');
}
</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();"> 

<div class="title_with_desc">访问控制 -- 密码</div>
<div class="title_01"  style="padding-left:10px;" width="100%">
访问路由器通过两个用户名来控制: telecomadmin和useradmin。<br>
用户名“telecomadmin”可以不受限制地浏览和修改路由器。<br> 
用户名“useradmin”可以访问路由器，浏览配置和统计表。</div>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
  <tr id="secUsername"> 
  <td class="width_40p">
  <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF" class="tabal_bg">
  <tr>
  <td class="table_title_pwd width_60p" BindText="s0f08"></td>
  <td class="table_right_pwd" id="Username_text"><script language="JavaScript" type="text/javascript">document.write(sptUserName);</script></td>
  </tr>
  <tr> 
  <td class="table_title_pwd width_60p" BindText="s0f09"></td>
  <td class="table_right_pwd"><input name='PwdNew_password' type="password" id="PwdNew_password" size="15" ></td> 
  </tr>
  <tr> 
  <td class="table_title_pwd width_60p" BindText="s0f0b"></td>
  <td class="table_right_pwd"><input name='PwdCfm_password' type='password' id="PwdCfm_password" size="15"></td> 
  </tr>
  </table>  </td>
  
  <td class="tabal_pwd_notice width_60p" id="PwdNotice" BindText="s1116a" >
  </td>
  </tr> 
</table> 

<div class="button_spread"></div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button"> 
  <tr> 
    <td class="table_submit width_25p"></td> 
    <td  class="table_submit" align="right"> 
	  <input  class="submit" name="Pwdptnsave_button" id="Pwdptnsave_button" type="button" onClick="SubmitPwd();"  value="保存/应用"> 
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">	  
	</td> 
  </tr> 
</table> 

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
    b.innerHTML = AccountLgeDes[c];
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
    b.value = AccountLgeDes[c];
}
</script>

</body>
</html>
