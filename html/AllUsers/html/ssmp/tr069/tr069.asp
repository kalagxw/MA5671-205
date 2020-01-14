<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src="<%HW_WEB_GetReloadCus(html/ssmp/tr069/tr069.cus);%>"></script>
<style>
form{padding:0;margin:0}
</style>
<script language="JavaScript" type="text/javascript">
var LoginRequestLanguage = '<%HW_WEB_GetLoginRequestLangue();%>';
var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
function title_show(input)
{
	var div=document.getElementById("title_show");

	if ("ARABIC" == LoginRequestLanguage.toUpperCase())
	{
		div.style.right = (input.offsetLeft+50)+"px";
	}
	else if ('LNCU' == CfgModeWord)
	{
		div.style.width ="250px";
		div.style.left = (input.offsetLeft+320)+"px";
	}
	else
	{
		div.style.left = (input.offsetLeft+390)+"px";
	}

	div.innerHTML = Tr069LgeDes['s1116'];
	div.style.display = '';
}

function title_back(input)
{
	var div=document.getElementById("title_show");
	div.style.display = "none";
}

function stCWMP(domain,PeriodicInformEnable,PeriodicInformInterval,PeriodicInformTime,URL,Username,ConnectionRequestUsername, X_HW_EnableCertificate, X_HW_DSCP, X_HW_CheckPasswordComplex)
{
	this.domain = domain;
	this.PeriodicInformEnable = PeriodicInformEnable;
	this.PeriodicInformInterval = PeriodicInformInterval;
	this.PeriodicInformTime = PeriodicInformTime;
	this.URL = URL;
	this.Username = Username;
	this.Password = "********************************";
	this.ConnectionRequestUsername = ConnectionRequestUsername;
	this.ConnectionRequestPassword = "********************************";
	this.X_HW_EnableCertificate  = X_HW_EnableCertificate ;
	this.X_HW_DSCP  = X_HW_DSCP;
	this.X_HW_CheckPasswordComplex = X_HW_CheckPasswordComplex;
}

function stManageFlag(ManageFlag)
{
	this.ManageFlag = ManageFlag;
}

var stCWMPs = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.ManagementServer,PeriodicInformEnable|PeriodicInformInterval|PeriodicInformTime|URL|Username|ConnectionRequestUsername|X_HW_EnableCertificate|X_HW_DSCP|X_HW_CheckPasswordComplex,stCWMP);%>;
var cwmp = stCWMPs[0];
var MngtMgts = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_MGTS);%>';
var AcsConfigFormList = new Array();
var SSLAcsConfigFormList = new Array();

function LoadFrame()
{
	if("undefined" != typeof(CusLoadFrame))
	{
		CusLoadFrame();
	}

	if( ( window.location.href.indexOf("complex.cgi?") > 0) )
	{
		AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d14"));
	}
}


function CheckTime(str_date)
{
	var date_reg = new RegExp("^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)$");
	var time_reg = new RegExp("^((0[0-9])|(1[0-9])|(2[0-3])):([0-5][0-9]):([0-5][0-9])$");

	date_time = str_date.split("T");
	if (date_time.length != 2)
	{
		return false;
	}

	if ((!date_reg.test(date_time[0])) || (!time_reg.test(date_time[1])))
	{
		return false;
	}

	return true;
}

function checkUrlPort(urlinfo)
{
	var url_values = urlinfo.split("://");

	if (url_values.length <= 1)
	{
		var port_value = urlinfo.split(":");

		if (port_value.length <= 1)
		{
			return true;
		}
		else
		{
			var othervalue = port_value[port_value.length-1].split("/");

			if (othervalue.length == 0)
			{
				return true;
			}

			if(true == isNull(othervalue[0]))
			{
				return false;
			}

			if(false == isNum(othervalue[0]))
			{
				return false;
			}

			var port = parseInt(othervalue[0], 10);
			if ((port >= 65536) || ( port < 1))
			{
				return false;
			}
			return true;
		}
	}
	else
	{
		var port_value = url_values[url_values.length-1].split(":");
		if (port_value.length <= 1)
		{
			return true;
		}

		var othervalue = port_value[port_value.length-1].split("/");
		if (othervalue.length == 0)
		{
			return true;
		}

		if(true == isNull(othervalue[0]))
		{
			return false;
		}

		if(false == isNum(othervalue[0]))
		{
			return false;
		}

		var port = parseInt(othervalue[0], 10);
		if ((port >= 65536) || ( port < 1))
		{
			return false;
		}
	}

	return true;
}

function CheckForm(type)
{
	with(document.getElementById("AcsConfigForm"))
	{
		if (URL.value == '')
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d01"));
			URL.focus();
			return false;
		}

		if (!isSafeStringSN(URL.value))
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d02"));
			URL.focus();
			return false;
		}

		if (!checkUrlPort(URL.value))
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d2d"));
			URL.focus();
			return false;
		}

		if ('' != isValidAscii(URL.value))
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d2e"));
			URL.focus();
			return false;
		}

		if (getCheckVal("PeriodicInformEnable") == 1)
		{
			if ((PeriodicInformInterval.value == '') || (isPlusInteger(PeriodicInformInterval.value) == false))
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d03"));
				PeriodicInformInterval.focus();
				return false;
			}

			var info = parseInt(PeriodicInformInterval.value,10);
			if (info < 1 || info > 2147483647)
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d03"));
				PeriodicInformInterval.focus();
				return false;
			}

			if (getValue('PeriodicInformTime') != '' && CheckTime(getValue('PeriodicInformTime')) == false)
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d04"));
				return false;
			}
		}

		if (Username.value == '')
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d05"));
			Username.focus();
			return false;
		}
		if (isValidString(Username.value) == false )
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d06"));
			Username.focus();
			return false;
		}

		if (Password.value == '')
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d07"));
			Password.focus();
			return false;
		}
		if (isValidString(Password.value) == false )
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d08"));
			Password.focus();
			return false;
		}

		if (MngtMgts == 0)
		{
			if (ConnectionRequestUsername.value == '')
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d09"));
				ConnectionRequestUsername.focus();
				return false;
			}
			if (isValidString(ConnectionRequestUsername.value) == false )
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0a"));
				ConnectionRequestUsername.focus();
				return false;
			}

			if ('' == ConnectionRequestPassword.value)
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0b"));
				ConnectionRequestPassword.focus();
				return false;
			}

			if (isValidString(ConnectionRequestPassword.value) == false )
			{
				AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0c"));
				ConnectionRequestPassword.focus();
				return false;
			}
		}

		var info = parseInt(X_HW_DSCP.value,10);
		if (info < 0 || info > 63)
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0d"));
			X_HW_DSCP.focus();
			return false;
		}

		if (ConnectionRequestPassword.value == '********************************')
		{
				if(CheckPwdIsComplex(Password.value,Username.value) == false
				   && Password.value !=  cwmp.Password)
				{
					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
						AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
						return false;
					}
					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d31")))
					{
						return false;
					}
				}
		}
		else
		{
			if(Password.value != cwmp.Password && ConnectionRequestPassword.value == cwmp.ConnectionRequestPassword)
			{
				if(CheckPwdIsComplex(Password.value,Username.value) == false)
				{
					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
							AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
							return false;
					}

					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d31")))
					{
						return false;
					}
				}
			}
			else if(Password.value == cwmp.Password && ConnectionRequestPassword.value != cwmp.ConnectionRequestPassword)
			{
				if(CheckPwdIsComplex(ConnectionRequestPassword.value,ConnectionRequestUsername.value) == false)
				{
					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
						 AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
						 return false;
					}

					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d32")))
					{
						return false;
					}
				}
			}
			else if(Password.value != cwmp.Password && ConnectionRequestPassword.value != cwmp.ConnectionRequestPassword)
			{
				if(CheckPwdIsComplex(Password.value,Username.value) == false
			   && CheckPwdIsComplex(ConnectionRequestPassword.value,ConnectionRequestUsername.value) == true)
				{
					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
							AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
							return false;
					}

					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d31")))
					{
						return false;
					}
				}
				else if(CheckPwdIsComplex(Password.value,Username.value) == true
				&& CheckPwdIsComplex(ConnectionRequestPassword.value,ConnectionRequestUsername.value) == false)
				{

					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
						 AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
						 return false;
					}

					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d32")))
					{
						return false;
					}
				}
				else if(CheckPwdIsComplex(Password.value,Username.value) == false
				&& CheckPwdIsComplex(ConnectionRequestPassword.value,ConnectionRequestUsername.value) == false)
				{
					if (cwmp.X_HW_CheckPasswordComplex == 1)
					{
						 AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1902"));
						 return false;
					}

					if(!ConfirmEx(GetDescFormArrayById(Tr069LgeDes, "s0d33")))
					{
						return false;
					}
				}
			}
			else
			{
				;
			}
		}
	}
	return true;
}

function VerifyFile(FileName)
{
	var File = document.getElementsByName(FileName)[0].value;
	if (File.length == 0)
	{
		AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d10"));
		return false;
	}
	if (File.length > 128)
	{
		AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d11"));
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
	top.previousPage = '/html/ssmp/reset/reset.asp';
	setDisable('btnSubmit',1);
	uploadForm.submit();
	setDisable('browse',1);
	setDisable('btnBrowse',1);
}

function CheckFormPassword(type)
{
	with(document.getElementById("TR069SSLCfg"))
	{
		if(X_HW_CertPassword.value.length > 32)
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0e"));
			setText('X_HW_CertPassword', '');
			setText("CfmPassword", "");
			return false;
		}

		if (X_HW_CertPassword.value == '')
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s1430"));
			return false;
		}

		if(X_HW_CertPassword.value != CfmPassword.value)
		{
			AlertEx(GetDescFormArrayById(Tr069LgeDes, "s0d0f"));
			setText("X_HW_CertPassword", "");
			setText("CfmPassword", "");
			return false;
		}
	}
	return true;
}

function AddSubmitImportcert()
{
	if (CheckFormPassword() == false)
	{
		return ;
	}

	var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_CertPassword',getValue('X_HW_CertPassword'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('complex.cgi?x=InternetGatewayDevice.ManagementServer'
						 + '&RequestFile=html/ssmp/tr069/tr069.asp');
	setDisable('PWDbtnApply',1);
	setDisable('PWDcancelValue',1);
	Form.submit();

}

function SetCertificateInfo()
{
	var Form = new webSubmitForm();
	var Value = getCheckVal('CertificateEnable');
	Form.addParameter('x.X_HW_EnableCertificate', Value);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.ManagementServer&RequestFile=html/ssmp/tr069/tr069.asp');
	Form.submit();
}

function CancelConfigPwd()
{
	if ( null != cwmp )
	{
		setCheck('CertificateEnable', cwmp.X_HW_EnableCertificate);
	}

	setText("X_HW_CertPassword", "");
	setText("CfmPassword", "");
}

function StartFileOpt()
{
	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
}

function EnableAcsInformFunc()
{
	var itemPeriodicInformEnable = document.getElementById("PeriodicInformEnable");
	var itemPeriodicInformInterval = document.getElementById("PeriodicInformInterval");
	var itemPeriodicInformTime = document.getElementById("PeriodicInformTime");
	if (true == itemPeriodicInformEnable.checked) {
		itemPeriodicInformInterval.disabled = false;
		itemPeriodicInformTime.disabled = false;
	} else {
		itemPeriodicInformInterval.disabled = true;
		itemPeriodicInformTime.disabled = true;
	}
}

function SubmitAcsConfig()
{
	if(false == CheckForm())
	{
		return;
	}

	var BaseData = HWcloneObject(cwmp, 1);
	var Parameter = {};
	Parameter.FormLiList = AcsConfigFormList;
	Parameter.OldValueList = BaseData;
	BaseData["URL"] = "";
	Parameter.SpecParaPair = null;
	var ConfigUrl = 'set.cgi?x=InternetGatewayDevice.ManagementServer&RequestFile=html/ssmp/tr069/tr069.asp';
	var tokenvalue = getValue('onttoken');
	Parameter.asynflag = null;
	var result = HWSetAction(null, ConfigUrl, Parameter, tokenvalue);
	if(result)
	{
		setDisable('ACSbtnApply',1);
		setDisable('ACScancelValue',1);
	}
}

function InitAcsTableList()
{
	var FillData = HWcloneObject(cwmp, 1);
	HWSetTableByLiIdList(AcsConfigFormList, FillData, EnableAcsInformFunc);
}

function InitSslAcsCfgBox()
{
	setCheck('CertificateEnable', cwmp.X_HW_EnableCertificate);
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
<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("TR069", GetDescFormArrayById(Tr069LgeDes, "s0101"), GetDescFormArrayById(Tr069LgeDes, "s0100"), false);
	</script>
	<div class="title_spread"></div>
	<div class="func_title" BindText="s0d15"></div><!-- function 1: usb Fast Restoration -->
	<form id="AcsConfigForm"  name="AcsConfigForm">
		<table id="AcsConfigFormPanel" width="100%" cellspacing="1" cellpadding="0">
			<li id="PeriodicInformEnable"      RealType="CheckBox"   DescRef="s0d17" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.PeriodicInformEnable"
				InitValue="Empty" ClickFuncApp="onClick=EnableAcsInformFunc"/>
			<li id="PeriodicInformInterval"    RealType="TextBox"    DescRef="s0d18" RemarkRef="s0d34" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.PeriodicInformInterval"    InitValue="Empty"/>
			<li id="PeriodicInformTime"        RealType="TextBox"    DescRef="s0d19" RemarkRef="s0d1a" ErrorMsgRef="Empty" Require="FALSE" BindField="x.PeriodicInformTime"        InitValue="Empty"/>
			<li id="URL"                       RealType="TextDivbox" DescRef="s0d2f" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.URL"
				InitValue="[{Item:[{AttrName:'id', AttrValue:'title_show'},{AttrName:'style', AttrValue:'position:absolute; display:none; line-height:16px; width:280px; border:solid 1px #999999; background:#edeef0;'}]}]"/>
			<li id="Username"                  RealType="TextBox"    DescRef="s0d1b" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.Username"                  InitValue="Empty"/>
			<li id="Password"                  RealType="TextBox"    DescRef="s0d1c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.Password"
				InitValue="Empty" ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
			<li id="ConnectionRequestUsername" RealType="TextBox"    DescRef="s0d1e" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.ConnectionRequestUsername" InitValue="Empty"/>
			<li id="ConnectionRequestPassword" RealType="TextBox"    DescRef="s0d1f" RemarkRef="Empty" ErrorMsgRef="Empty" Require="TRUE"  BindField="x.ConnectionRequestPassword"
				InitValue="Empty" ClickFuncApp="onmouseover=title_show;onmouseout=title_back"/>
			<li id="X_HW_DSCP"                 RealType="TextBox"    DescRef="s0d30" RemarkRef="s0d35" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_DSCP"                 InitValue="Empty"/>
		</table>
		<script>
			AcsConfigFormList = HWGetLiIdListByForm("AcsConfigForm", null);
			var TableClass = new stTableClass("width_per30", "width_per70", "");
			HWParsePageControlByID("AcsConfigForm", TableClass, Tr069LgeDes, AcsReload);
			InitAcsTableList();
		</script>
		<table id="ConfigPanelButtons" width="100%" cellspacing="1" class="table_button">
			<tr>
				<td class="width_per30"></td>
				<td class="table_submit">
					<input type="button" id="ACSbtnApply"    value="" BindText="s0d21" class="ApplyButtoncss  buttonwidth_100px" onclick="SubmitAcsConfig();" />
					<input type="button" id="ACScancelValue" value="" BindText="s0d22" class="CancleButtonCss buttonwidth_100px" onclick="InitAcsTableList();" />
				</td>
			</tr>
		</table>
	</form>

	<div class="func_spread"></div>
	<div class="func_title" BindText="s0d23"></div><!-- function 2: SSL Configuration -->
	<form id="TR069SSLCfg">
		<table id="SslAcsConfigFormPanel" width="100%" cellspacing="1" cellpadding="0">
			<li id="CertificateEnable" RealType="CheckBox" DescRef="s0d25" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.PeriodicInformEnable"  InitValue="Empty" ClickFuncApp="onClick=SetCertificateInfo"/>
			<li id="X_HW_CertPassword" RealType="TextBox"  DescRef="s0d26" RemarkRef="s0d27" ErrorMsgRef="Empty" Require="FALSE" BindField="x.X_HW_CertPassword"  InitValue="Empty"/>
			<li id="CfmPassword"       RealType="TextBox"  DescRef="s0d28" RemarkRef="s0d27" ErrorMsgRef="Empty" Require="FALSE" BindField="CfmPassword"  InitValue="Empty"/>
		</table>
		<script>
			SSLAcsConfigFormList = HWGetLiIdListByForm("TR069SSLCfg", null);
			var TableClass = new stTableClass("width_per30", "width_per70", "");
			HWParsePageControlByID("TR069SSLCfg", TableClass, Tr069LgeDes, null);
			InitSslAcsCfgBox();
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="width_per30"></td>
				<td class="table_submit">
					<input type="button" name="PWDbtnApply"    id="PWDbtnApply"    class="ApplyButtoncss  buttonwidth_100px" BindText="s0d21" onClick="AddSubmitImportcert();">
					<input type="button" name="PWDcancelValue" id="PWDcancelValue" class="CancleButtonCss buttonwidth_100px" BindText="s0d22" onClick="CancelConfigPwd();">
				</td>
			</tr>
		</table>
	</form>

	<div class="func_spread"></div>
	<div class="func_title" BindText="s0d29"></div><!-- function 3: Import Certificate -->
	<form action="certification.cgi?RequestFile=html/ssmp/reset/reset.asp" method="post" enctype="multipart/form-data" name="fr_uploadImage" id="fr_uploadImage">
		<div>
			<table>
				<tr>
					<td class="filetitle" BindText="s0d2a"></td>
					<td>
						<div class="filewrap">
							<div class="fileupload">
								<input type="hidden" id="onttoken"  name="onttoken"    value="<%HW_WEB_GetToken();%>" />
								<input type="text"   id="f_file"    autocomplete="off" readonly="readonly" />
								<input type="file"   id="t_file"    name="browse"      size="1"  onblur="StartFileOpt();" onchange="fchange();" />
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
	<script>
		ParseBindTextByTagName(Tr069LgeDes, "div",   1);
		ParseBindTextByTagName(Tr069LgeDes, "td",    1);
		ParseBindTextByTagName(Tr069LgeDes, "input", 2);
	</script>
<br>
</body>
</html>
