<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" type="text/javascript">
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
var UnicomFlag = "<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_MNGT_UNICOM);%>";
function Check_SWM_Status()
{
	var xmlHttp = null;

	if(window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else if(window.ActiveXObject) {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlHttp.open("GET", "../../get_swm_status.asp", false);
	xmlHttp.send(null);

	var swm_status = xmlHttp.responseText;
	if (swm_status.substr(1,1) == "0") {
		return true;
	} else {
		return false;
	}
}

function setAllDisable()
{
	setDisable('f_file',1);
	setDisable('browse',1);
	setDisable('btnBrowse',1);
	setDisable('btnSubmit',1);
}
function GetLanguageDesc(Name)
{
	return CfgfileLgeDes[Name];
}

function LoadFrame() {
	if (curUserType != sysUserType) {
		setDisplay('saveConfig',     1);
		setDisplay('downloadConfig', 0);
		setDisplay('uploadConfig',   0);
	}
	else
	{
		setDisplay('downloadConfig', 1);
		setDisplay('uploadConfig',   1);
		if (1 == UnicomFlag)
		{
			setDisplay('saveConfig', 0);
		}
		else
		{
			setDisplay('saveConfig', 1);
		}
	}

	if (top.SaveDataFlag == 1)
	{
		 top.SaveDataFlag = 0;
		 AlertEx(GetLanguageDesc("s0701"));
	}

	if((curWebFrame == 'frame_argentina') &&(curUserType == sysUserType))
	{
		setAllDisable();
	}
}

function CheckForm(type) {
	with(document.getElementById("ConfigForm")) {
	}
	return true;
}

function AddSubmitParam(SubmitForm, type) {
}

function VerifyFile(FileName)
{
	var filePath = document.getElementsByName(FileName)[0].value;

	if (filePath.length == 0) {
		AlertEx(GetLanguageDesc("s0702"));
		return false;
	}

	if (filePath.length > 128) {
		AlertEx(GetLanguageDesc("s0703"));
		return false;
	}

	return true;
}

function uploadSetting() {
	var uploadForm = document.getElementById("fr_uploadSetting");

	if (Check_SWM_Status() == false) {
		AlertEx(GetLanguageDesc("s0905"));
		return;
	}
	if (VerifyFile('browse') == false) {
		return;
	}

	if(!ConfirmEx(GetLanguageDesc("s0711")))
	{
		return;
	}
	top.previousPage = '/html/ssmp/reset/reset.asp';
	setDisable('btnSubmit', 1);
	uploadForm.submit();
	setDisable('browse',1);
	setDisable('btnBrowse',1);

}

function backupSetting() {

	var Form = new webSubmitForm();
	Form.setAction('cfgfiledown.cgi?&RequestFile=html/ssmp/cfgfile/cfgfile.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function SaveSetting() {
	var Form = new webSubmitForm();
	Form.setMethod('POST');
	top.SaveDataFlag = 1;
	Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave' + '&RequestFile=html/ssmp/cfgfile/cfgfile.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function SaveandReboot()
{
	if(ConfirmEx(GetLanguageDesc("s0706")))
	{
		setDisable('btnsaveandreboot', 1);
		var Form = new webSubmitForm();
		Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard' + '&RequestFile=html/ssmp/cfgfile/cfgfile.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
}

</script>
<script language="JavaScript" type="text/javascript">

function fchange()
{
	var ffile = document.getElementById("f_file");
	var tfile = document.getElementById("t_file");
	ffile.value = tfile.value;

	var buttonstart = document.getElementById('btnSubmit');
	buttonstart.focus();
	return ;
}

function StartFileOpt()
{
	XmlHttpSendAspFlieWithoutResponse("../common/StartFileLoad.asp");
}

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("cfgfile", GetDescFormArrayById(CfgfileLgeDes, "s0102"), GetDescFormArrayById(CfgfileLgeDes, "s0100"), false);
	</script>
	<div class="title_spread"></div>
	<div id="saveConfig">
		<div class="func_title" BindText="s0101"></div>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td><input style="width:150px" class="ApplyButtoncss buttonwidth_150px_250px" name="saveconfigbutton" id="saveconfigbutton" type='button' onClick='SaveSetting()' BindText="s0709" /></td>
				<td><input style="width:150px" class="ApplyButtoncss buttonwidth_150px_250px" name="btnsaveandreboot" id="btnsaveandreboot" type='button' onClick='SaveandReboot()' BindText="s070a" /></td>
			</tr>
		</table>
	</div>
	<div class="func_spread"></div>
	<div id="downloadConfig" style="display:none">
		<div class="func_title" BindText="s070c"></div>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td><input class="ApplyButtoncss buttonwidth_150px_250px" name="downloadconfigbutton" id="downloadconfigbutton" type='button' onClick='backupSetting()' BindText="s070c"></td>
			</tr>
		</table>
	</div>
	<div class="func_spread"></div>
	<div id="uploadConfig" style="display:none">
		<form action="cfgfileupload.cgi?RequestFile=html/ssmp/reset/reset.asp&FileType=config&RequestToken=<%HW_WEB_GetToken();%>" method="post" enctype="multipart/form-data" name="fr_uploadSetting" id="fr_uploadSetting">
			<div class="func_title" BindText="s0710"></div>
			<table>
				<tr>
					<td class="filetitle" BindText="s070e"></td>
					<td>
						<div class="filewrap">
							<div class="fileupload">
								<input type="hidden" id="hwonttoken" name="onttoken" value="<%HW_WEB_GetToken();%>" />
								<input type="text"   id="f_file"     autocomplete="off" readonly="readonly" />
								<input type="file"   id="t_file"     name="browse" size="1"  onblur="StartFileOpt();" onchange="fchange();" />
								<input type="button" id="btnBrowse"  class="CancleButtonCss filebuttonwidth_100px" BindText="s070f" />
							</div>
						</div>
					</td>
					<td>
						<input type='button' id="btnSubmit" name="btnSubmit" class="CancleButtonCss filebuttonwidth_150px_250px" onclick='uploadSetting();' BindText="s0710" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<div class="func_spread"></div>

	<script>
		ParseBindTextByTagName(CfgfileLgeDes, "div",    1);
		ParseBindTextByTagName(CfgfileLgeDes, "td",     1);
		ParseBindTextByTagName(CfgfileLgeDes, "input",  2);
	</script>

</body>
</html>
