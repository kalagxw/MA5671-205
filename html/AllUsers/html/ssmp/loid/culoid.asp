<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type='text/css'>
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

var LoidPwdInfo = AuthInfo[0];
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var CfgFtWordArea = '<%GetConfigAreaInfo();%>';
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
function LoadFrame()
{
     if(CfgFtWordArea.toUpperCase() != 'NOCHOOSE' && CfgFtWordArea.toUpperCase() != 'CHOOSE' )
    {
      document.getElementById("DivAuthentication").style.display = "";
    }
    else if(CfgFtWordArea.toUpperCase() == 'NOCHOOSE')
  	{	
			document.getElementById("DivAuthentication").style.display = "";		
  	}
	else if(CfgMode == 'UNICOMBRIDGE')
	{
		window.location = "/html/hide/password.asp";
		return;
	}
  	else
	{
		window.parent.document.location.href = "/loidreg.asp";
		return;
	}

    setText("username", LoidPwdInfo.Loid);	
    if (MngtGdct != 1)
    {
        setText("userid", LoidPwdInfo.Password);
    }
	if ( ('LNCU' == CfgMode.toUpperCase()) && (curUserType != sysUserType) )
    {
        setDisable("username",1);
        setDisable("userid",1);
        setDisable("setbutton",1);
        setDisable("cancel",1);
    }    
    
}

function CheckForm()
{
    var username = document.getElementById("username");
    var userid = document.getElementById("userid");
	
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
	setDisable('cancel', 1);
	return true;
}

function AddSubmitParam(SubmitForm,type)
{
	SubmitForm.addParameter('x.UserName',getValue('username'));	
	SubmitForm.addParameter('x.UserId',getValue('userid'));

	SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.X_HW_UserInfo'
							 + '&RequestFile=html/ssmp/loid/culoid.asp');	 
}

function CancelValue()
{
	setText("username", LoidPwdInfo.Loid);

    if (MngtGdct != 1)
    {
        setText("userid", LoidPwdInfo.Password);
    }
    else
    {
        setText("userid", "");
    }
}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div name="DivAuthentication" id="DivAuthentication"  style="display:none">	
<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
  <tr> 
    <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class="title_01"  style="padding-left:10px;" width="100%"> <script language="JavaScript" type="text/javascript">
			if (top.manageFlag == 1)
			{
				document.write("您可以通过设置LOID和Password，然后点击“认证”按钮向网管服务器注册并请求业务配置。");
			}
			else
			{
				document.write("您可以通过设置LOID和Password，然后点击“认证”按钮向网管服务器注册并请求业务配置。");
			}
			</script> </td> 
        </tr> 
      </table></td> 
  </tr> 
</table> 
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
  <tr id="TroldPassword"> 
    <td  class="table_title" align="left" width='25%'>LOID:</td> 
    <td  class="table_right" align="left" colspan="6" width='75%'>
    	<input name='username' type="text" id="username" maxlength="24"> 
      <strong style="color:#FF0033">*</strong>
      <span class="gray"><script>document.write("(字符串最多包含24个英文字符或数字)");</script></span>
      </td> 
  </tr> 
  <tr> 
    <td class="table_title"  align="left" width='25%'>Password:</td> 
    <td class="table_right"   align="left" colspan="6" width='75%'>
    	 <input name='userid' type="text" id="userid" maxlength="12">
    	 <span class="gray"><script>document.write("(字符串最多包含12个英文字符或数字)");</script></span>
    </td> 
  </tr> 
</table> 
<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
  <tr> 
    <td class="table_submit" width='25%'></td> 
    <td  class="table_submit" align="left"> 
	 <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	<input  class="submit" name="setbutton" id="setbutton" type="button" onClick="Submit();" value="认证"> 
      <input class="submit" name="cancel" id="cancel" type="button" onClick="CancelValue();" value="取消"> </td> 
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
