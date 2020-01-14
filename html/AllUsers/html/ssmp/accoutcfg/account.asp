<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(md5.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(RndSecurityFormat.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function GetLanguageDesc(Name)
{
	return AccountLgeDes[Name];
}

function stNormalUserInfo(UserName, ModifyPasswordFlag, InstantNo)
{
	this.UserName = UserName;
	this.ModifyPasswordFlag = ModifyPasswordFlag;
	this.InstantNo = InstantNo;
}

var UserInfo = <%HW_WEB_GetNormalUserInfo(stNormalUserInfo);%>;

var sptUserName = UserInfo[0].UserName;
var sptInstantNo = UserInfo[0].InstantNo;

var PwdModifyFlag = 0;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';

function setAllDisable()
{
	setDisable('newUsername',1);
	setDisable('oldPassword',1);
	setDisable('newPassword',1);
	setDisable('cfmPassword',1);
	setDisable('MdyPwdApply',1);
	setDisable('MdyPwdcancel',1);
}

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
	document.getElementById('WebUserName').appendChild(document.createTextNode(TextTranslate(sptUserName)));
	if( ( window.location.href.indexOf("set.cgi?") > 0) )
	{
		AlertEx(GetLanguageDesc("s0f0e"));
	}

	if((curWebFrame == 'frame_argentina') &&(curUserType != sysUserType))
	{
		setAllDisable();
	}

	PwdModifyFlag = UserInfo[0].ModifyPasswordFlag;

	if((parseInt(PwdModifyFlag,10) == 0) && (curLanguage.toUpperCase() != "CHINESE"))
	{
		 document.getElementById('tabledefaultpwdnotice').style.display="block";
		 document.getElementById('defaultpwdnotice').innerHTML=GetLanguageDesc("s1118");
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
	var oldPassword = document.getElementById("oldPassword");
	var newPassword = document.getElementById("newPassword");
	var cfmPassword = document.getElementById("cfmPassword");

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

function SubmitPwd()
{
	if(!CheckParameter())
	{
		return false;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x.Password',getValue('newPassword'));
	Form.addParameter('x.OldPassword',getValue('oldPassword'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.' + sptInstantNo
						 + '&RequestFile=html/ssmp/accoutcfg/account.asp');
	Form.submit();
}

function GetLanguageDesc(Name)
{
	return AccountLgeDes[Name];
}

function CancelValue()
{
	setText('oldPassword','');
	setText('newPassword','');
	setText('cfmPassword','');
}
</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("account", GetDescFormArrayById(AccountLgeDes, "s0102"), GetDescFormArrayById(AccountLgeDes, "s0f12"), false);
	</script>
	<div class="title_spread"></div>

	<table id="tabledefaultpwdnotice" width="100%" border="0" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td id="defaultpwdnotice"></td>
		</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<tr id="secUsername">
			<td class="width_per40">
				<form id="PwdChangeCfgForm"  name="PwdChangeCfgForm">
					<table id="PwdChangeCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF">
						<li id="WebUserName" RealType="HtmlText" DescRef="s0f08" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="WebUserName"   InitValue="Empty"/>
						<li id="oldPassword" RealType="TextBox"  DescRef="s0f13" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.OldPassword" InitValue="Empty"/>
						<li id="newPassword" RealType="TextBox"  DescRef="s0f09" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Password"    InitValue="Empty"/>
						<li id="cfmPassword" RealType="TextBox"  DescRef="s0f0b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"         InitValue="Empty"/>
					</table>
					<script>
						var PwdChangeCfgFormList = new Array();
						PwdChangeCfgFormList = HWGetLiIdListByForm("PwdChangeCfgForm", null);
						var TableClass = new stTableClass("width_per60", "width_per40");
						HWParsePageControlByID("PwdChangeCfgForm", TableClass, AccountLgeDes, null);

						var PwdChangeArray = new Array();

						
						HWSetTableByLiIdList(PwdChangeCfgFormList, PwdChangeArray, null);
					</script>
				</form>
			</td>
			<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1116a"></td>
		</tr>
	</table>

	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
		<tr>
			<td class="table_submit width_per25"></td>
			<td  class="table_submit">
				<input type="button" id="MdyPwdApply"  name="MdyPwdApply"  class="ApplyButtoncss buttonwidth_100px"  onClick="SubmitPwd();"   BindText="s0f0c">
				<input type="button" id="MdyPwdcancel" name="MdyPwdcancel" class="CancleButtonCss buttonwidth_100px" onClick="CancelValue();" BindText="s0f0d">
				<input type="hidden" id="hwonttoken"   name="onttoken"     value="<%HW_WEB_GetToken();%>">
			</td>
		</tr>
	</table>

	<script>
		var ele = document.getElementById("divTablePwdChangeCfgForm");
		ele.setAttribute('class', '');

		ele = document.getElementById("PwdNotice");
		ele.style.background = '#FFFFFF';

		ParseBindTextByTagName(AccountLgeDes, "td",     1);
		ParseBindTextByTagName(AccountLgeDes, "input",  2);
	</script>
</body>
</html>
