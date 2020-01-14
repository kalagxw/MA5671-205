<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">

var MultiUser = 0;
var CfgMode ='<%HW_WEB_GetCfgMode();%>';

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

function stSSLWeb(domain,Enable)
{
	this.domain = domain;
	this.Enable   = Enable;
}

var stModifyUserInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebUserInfo.{i}, UserName|UserLevel, stModifyUserInfo);%>;
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var stSSLWebs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.UserInterface.X_HW_WebSslInfo,Enable,stSSLWeb);%>;
var SSLConfig = stSSLWebs[0];

var IsSurportWebsslPage  = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_WEBSSLPAGE);%>';
if (3 < stModifyUserInfos.length)
{
	MultiUser = 1;
}

for (var i = 0; i < stModifyUserInfos.length - 1; i++)
{
	if(stModifyUserInfos[i].UserLevel == 1 )
	{
		sptUserName = stModifyUserInfos[i].UserName;
	}
}


function title_show(input)
{
	var div=document.getElementById("title_show");

	if ("ARABIC" == LoginRequestLanguage.toUpperCase())
	{
		div.style.right = (input.offsetLeft+50)+"px";
	}
	else
	{
		div.style.left = (input.offsetLeft+375)+"px";
	}

	div.innerHTML = WebcertmgntLgeDes['s1116'];
	div.style.display = '';
}
function title_back(input)
{
	var div=document.getElementById("title_show");
	div.style.display = "none";
}

function WriteUserListOption(val)
{
	if (stModifyUserInfos != 'null')
	{
		var output = '<select id="WebUserList" name="WebUserList" >';
		for (i = 0; i < stModifyUserInfos.length - 1; i++)
		{
			if ((stModifyUserInfos[i].UserLevel != 0) || ('ANTEL' == CfgMode.toUpperCase()))
			{
				output += '<option value=' + (i+1) + '>' + stModifyUserInfos[i].UserName + '</option>';
			}
		}
		output +="</select>" ;

		$("#" + val).append(output);
		return true;
	}
	else
	{
		return false;
	}
}

function CheckFormPassword(type)
{
	with(document.getElementById("WebcertCfgForm"))
	{
		if(WebcertPassword.value.length > 127)
		{
			AlertEx(GetLanguageDesc("s1904"));
			setText('WebcertPassword', '');
			setText("WebCfmPassword", "");
			return false;
		}

		if (WebcertPassword.value == '')
		{
			AlertEx(GetLanguageDesc("s1430"));
			return false;
		}

		if(WebcertPassword.value != WebCfmPassword.value)
		{
			AlertEx(GetLanguageDesc("s0d0f"));
			setText("WebcertPassword", "");
			setText("WebCfmPassword", "");
			return false;
		}

		if(CheckPwdIsComplex(WebcertPassword.value) == false)
		{
			AlertEx(GetLanguageDesc("s1902"));
			return false;
		}
	}
	return true;
}


function VerifyFile(FileName)
{
	var File = document.getElementsByName(FileName)[0].value;
	if (File.length == 0)
	{
		AlertEx(GetLanguageDesc("s0d10"));
		return false;
	}
	if (File.length > 128)
	{
		AlertEx(GetLanguageDesc("s0d11"));
		return false;
	}

	return true;
}

function uploadCert()
{
	var uploadForm = document.getElementById("fr_uploadImage");
	if (VerifyFile('browse') == false)
	{
	   return;
	}
	top.previousPage = '/html/ssmp/accoutcfg/accountadmin.asp';
	setDisable('btnSubmit',1);
	uploadForm.submit();
	setDisable('browse',1);
	setDisable('btnBrowse',1);
}

function AddSubmitImportcert()
{
	if (CheckFormPassword() == false)
	{
		return ;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x.CertPassword',getValue('WebcertPassword'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('complex.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebSslInfo'
						 + '&RequestFile=html/ssmp/accoutcfg/accountadmin.asp');

	setDisable('WebbtnApply',1);
	setDisable('WebcancelValue',1);
	Form.submit();
}

function SetCertificateInfo()
{
	var Form = new webSubmitForm();
	var Value = getCheckVal('WebCertificateEnable');

	Form.addParameter('x.Enable', Value);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.UserInterface.X_HW_WebSslInfo&RequestFile=html/ssmp/accoutcfg/accountadmin.asp');
	Form.submit();
}

function StartFileOpt()
{
	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
}

function CancelConfigPwd()
{
	setText("WebcertPassword", "");
	setText("WebCfmPassword", "");
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
	if( 1 == IsSurportWebsslPage )
	{
		setDisplay("websslpage",1);
	}

	if ( null != SSLConfig )
	{
		setCheck('WebCertificateEnable', SSLConfig.Enable);
	}

	if( ( window.location.href.indexOf("complex.cgi?") > 0) )
	{
		AlertEx(GetLanguageDesc("s0d14"));
	}

	if( ( window.location.href.indexOf("X_HW_WebUserInfo") > 0) )
	{
		if ('ANTEL' == CfgMode.toUpperCase())
		{
			AlertEx(GetLanguageDesc("s0f0e"));
		}
		else
		{
			AlertEx(GetLanguageDesc("s0f01"));
		}
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

	var newPassword = document.getElementById("newPassword");
	var cfmPassword = document.getElementById("cfmPassword");

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

	setDisable('MdyPwdApply', 1);
	setDisable('MdyPwdcancel', 1);

	return true;
}

function SubmitPwd()
{
	if (!CheckParameter())
	{
		return false;
	}
	var Form = new webSubmitForm();
	var InstNo = 1;

	if (1 == MultiUser)
	{
		InstNo = getValue('WebUserList');
	}

	Form.addParameter('x.Password',getValue('newPassword'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=' + stModifyUserInfos[InstNo - 1].domain
						 + '&RequestFile=html/ssmp/accoutcfg/accountadmin.asp');
	Form.submit();
}

function GetLanguageDesc(Name)
{
	return AccountLgeDes[Name];
}

function CancelValue()
{
	setText('newPassword','');
	setText('cfmPassword','');
}
function InitSslCfgBox()
{
	if ( null != SSLConfig )
	{
		setCheck('WebCertificateEnable', SSLConfig.Enable);
	}
}

function fchange() {
	var ffile = document.getElementById("f_file");
	var tfile = document.getElementById("t_file");
	ffile.value = tfile.value;

	var buttonstart = document.getElementById('ImportCertification');
	buttonstart.focus();
}
</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		if(1 == IsSurportWebsslPage)
		{
			HWCreatePageHeadInfo("accountadmin", GetDescFormArrayById(AccountLgeDes, "s0102"), GetDescFormArrayById(AccountLgeDes, "s0100"), false);
		}
		else
		{
			HWCreatePageHeadInfo("accountadmin", GetDescFormArrayById(AccountLgeDes, "s0102"), GetDescFormArrayById(AccountLgeDes, "s0f07"), false);
		}
	</script>
	<div class="title_spread"></div>
	<div class="func_title" BindText="s0101"></div>
	<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<tr id="secUsername">
			<td class="width_per40">
				<form id="PwdChangeCfgForm"  name="PwdChangeCfgForm">
					<table id="PwdChangeCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#FFFFFF">
						<li id="WebUserName" RealType="HtmlText" DescRef="s0f08" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="WebUserName" InitValue="Empty"/>
						<li id="newPassword" RealType="TextBox"  DescRef="s0f09" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Password"  InitValue="Empty"/>
						<li id="cfmPassword" RealType="TextBox"  DescRef="s0f0b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Empty"       InitValue="Empty"/>
					</table>
					<script>
						var PwdChangeCfgFormList = new Array();
						PwdChangeCfgFormList = HWGetLiIdListByForm("PwdChangeCfgForm", null);
						var TableClass = new stTableClass("width_per60", "width_per40");
						HWParsePageControlByID("PwdChangeCfgForm", TableClass, AccountLgeDes, null);
						if (1 == MultiUser)
						{
							WriteUserListOption("WebUserName");
						}
						else
						{
							var PwdChangeArray = new Array();
							PwdChangeArray["WebUserName"] = sptUserName;
							HWSetTableByLiIdList(PwdChangeCfgFormList, PwdChangeArray, null);
						}
					</script>
				</form>
			</td>
			<td class="tabal_pwd_notice width_per60" id="PwdNotice" BindText="s1116a"></td>
		</tr>
	</table>

	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
		<tr>
			<td class="table_submit width_per25"></td>
			<td class="table_submit">
				<input type="button" id="MdyPwdApply"  name="MdyPwdApply"  class="ApplyButtoncss buttonwidth_100px"  onClick="SubmitPwd();"    BindText="s0f0c" />
				<input type="button" id="MdyPwdcancel" name="MdyPwdcancel" class="CancleButtonCss buttonwidth_100px" onClick="CancelValue();"  BindText="s0f0d" />
				<input type="hidden" id="hwonttoken"   name="onttoken"     value="<%HW_WEB_GetToken();%>">
			</td>
		</tr>
	</table>
	<div id="websslpage" style="display:none;">
	<div class="func_spread"></div>
		<div class="func_title" BindText="s0d23"></div>
		<form id="WebcertCfgForm">
			<table id="WebcertCfgFormPanel" width="100%" cellspacing="1" cellpadding="0">
				<li   id="WebCertificateEnable"   RealType="CheckDivBox"   DescRef="s0d25"    RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.Enable"
				InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:310px; border:solid 1px #999999; background:#edeef0;'}]}]" ClickFuncApp="onClick=SetCertificateInfo"/>
				<li   id="WebcertPassword"   RealType="TextBox"    DescRef="s0d26"    RemarkRef="s1905"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="x.CertPassword"
				 ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
				<li   id="WebCfmPassword"   RealType="TextBox"    DescRef="s0d28"    RemarkRef="s1905"     ErrorMsgRef="Empty"    Require="FALSE"     BindField="CfmPassword"  InitValue="Empty"/>
			</table>
			<script>
				var WebcertCfgFormList = new Array();
				WebcertCfgFormList = HWGetLiIdListByForm("WebcertCfgForm", null);
				var TableClass = new stTableClass("width_per20", "width_per80", "");
				HWParsePageControlByID("WebcertCfgForm", TableClass, AccountLgeDes, null);
				InitSslCfgBox();
			</script>
			<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
				<tr>
					<td class="width_per25"></td>
					<td class="table_submit">
						<input type="button" id="PWDbtnApply"    name="PWDbtnApply"    class="ApplyButtoncss buttonwidth_100px"  BindText="s0d21" onClick="AddSubmitImportcert();">
						<input type="button" id="PWDcancelValue" name="PWDcancelValue" class="CancleButtonCss buttonwidth_100px" BindText="s0d22" onClick="CancelConfigPwd();">
					</td>
				</tr>
			</table>
		</form>
		<div class="func_spread"></div>
		<form action="websslcert.cgi?RequestFile=html/ssmp/accoutcfg/accountadmin.asp" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
			<div>
				<div class="func_title" BindText="s0d29"></div>
				<table>
					<tr>
						<td class="filetitle" BindText="s0d2a"></td>
						<td>
							<div class="filewrap">
								<div class="fileupload">
									<input type="text"   id="f_file" autocomplete="off" readonly="readonly" />
									<input type="file"   id="t_file" name="browse" size="1"  onblur="StartFileOpt();" onchange="fchange();" />
									<input type="button" id="btnBrowse" class="CancleButtonCss filebuttonwidth_100px" BindText="s0d2b" />
								</div>
							</div>
						</td>
						<td>
							<input class="CancleButtonCss filebuttonwidth_100px" id="ImportCertification" name="btnSubmit" type='button' onclick='uploadCert();' BindText="s0d2c" />
						</td>
					</tr>
				</table>
			</div>
		</form>
		<div class="func_spread"></div>
	</div>
	<script>
		var ele = document.getElementById("divTablePwdChangeCfgForm");
		ele.setAttribute('class', '');

		ele = document.getElementById("WebcertPassword");
		ele.setAttribute('title', '');

		ele = document.getElementById("WebCfmPassword");
		ele.setAttribute('title', '');

		ele = document.getElementById("PwdNotice");
		ele.style.background = '#FFFFFF';

		ParseBindTextByTagName(AccountLgeDes, "div",    1);
		ParseBindTextByTagName(AccountLgeDes, "td",     1);
		ParseBindTextByTagName(AccountLgeDes, "input",  2);
	</script>
</body>
</html>
