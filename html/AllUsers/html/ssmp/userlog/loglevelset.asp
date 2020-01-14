<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" type='text/css' href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>'>
<link rel="stylesheet" type='text/css' href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
function stSyslogCfg(domain, Enable, Level)
{
	this.domain = domain;
	this.Enable = Enable;
	this.Level  = Level;
}

var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Syslog, Enable|Level, stSyslogCfg);%>;
var SyslogCfg = temp[0];

function setLogEnable(id, flag)
{
	if ((flag != null) && (flag == 1 || flag == '1' || flag))
	{
		document.getElementById(id + "1").checked = true;
	}
	else
	{
		document.getElementById(id + "2").checked = true;
	}
}

function getLogEnable(id)
{
	if (document.getElementById(id + "1").checked)
		return 1;
	else
		return 0;
}

function LoadFrame()
{
	setLogEnable("LogEnable", parseInt(SyslogCfg.Enable))
	setSelect('Level', SyslogCfg.Level);
}

function CheckForm()
{
	return true;
}

function CancelConfig()
{
	setLogEnable("LogEnable", SyslogCfg.Enable)
	setSelect('Level', SyslogCfg.Level);
}

function AddSubmitParam(SubmitForm, type)
{
	SubmitForm.addParameter('x.Enable', getLogEnable("LogEnable"));
	SubmitForm.addParameter('x.Level',  getSelectVal('Level'));
	SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_Syslog'
					   + '&RequestFile=html/ssmp/userlog/loglevelset.asp');

	setDisable('btnApply',    1);
	setDisable('cancelValue', 1);
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("logview", GetDescFormArrayById(LogviewLgeDes, "s0101"), GetDescFormArrayById(LogviewLgeDes, "s0d01"), false);
	</script>
	<div class="title_spread"></div>
	<form id="LogEnableCfgForm">
		<table id="LogEnableCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1">
			<li id="LogEnable" RealType="RadioButtonList" DescRef="s0b03" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Enable"     
				InitValue="[{TextRef:'s0d03',Value:'Enable'},{TextRef:'s0d04',Value:'Forbid'}]"/>
			<li id="Level"     RealType="DropDownList"    DescRef="s0b04" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Level"
				InitValue="[{TextRef:'s0b05',Value:'0'},{TextRef:'s0b06',Value:'1'},{TextRef:'s0b07',Value:'2'},{TextRef:'s0b08',Value:'3'},{TextRef:'s0b09',Value:'4'},{TextRef:'s0b0a',Value:'5'},{TextRef:'s0b0b',Value:'6'},{TextRef:'s0b0c',Value:'7'}]"/>
		</table>
		<script>
			var LogEnableCfgFormList = new Array();
			LogEnableCfgFormList = HWGetLiIdListByForm("LogEnableCfgForm", null);
			var TableClass = new stTableClass("width_per20", "width_per80");
			HWParsePageControlByID("LogEnableCfgForm", TableClass, LogviewLgeDes, null);
		</script>
	</form>
	<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
		<tr>
			<td class="table_submit width_per20"></td>
			<td class="table_submit" align="left">
				<input type="hidden" name="onttoken"    id="hwonttoken"  value="<%HW_WEB_GetToken();%>">
				<input type="button" name="btnApply"    id="btnApply"    class="ApplyButtoncss buttonwidth_150px_250px"  BindText="s0b0d" onClick="Submit();">
				<input type="button" name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_150px_250px" BindText="s0b0e" onClick="CancelConfig();">
			</td>
		</tr>
	</table>
	<script>
		ParseBindTextByTagName(LogviewLgeDes, "input",  2);
	</script>
</body>
</html>
