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
function stSyslogCfg(domain,Enable,Level)
{
	this.domain = domain;
	this.Enable = Enable;
	this.Level = Level;
}
var CfgMode ='<%HW_WEB_GetCfgMode();%>';
var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Syslog, Enable|Level, stSyslogCfg);%>;
var SyslogCfg = temp[0];
var curLanguage = '<%HW_WEB_GetCurrentLanguage();%>';

function LoadFrame()
{
	setCheck('LogEnable', SyslogCfg.Enable);
	setSelect('Level', SyslogCfg.Level);

	top.SaveLogContent = document.getElementById("logarea").value;
	setDisable('Level',1);

	if(curLanguage.toUpperCase() != "CHINESE")
	{
		setDisable('LogEnable',   1);
		setDisable('btnApply',    1);
		setDisable('cancelValue', 1);
	}
}

function GetLogTypeDes(key)
{
	if ('SONET' == CfgMode.toUpperCase() || 'SONETHG8040H' == CfgMode.toUpperCase() || 'JAPAN8045D' == CfgMode.toUpperCase())
	{
		if("0" == key) return '[構成ログ]';
		if("1" == key) return '[シェルログ]';
		if("2" == key) return '[アラームログ]';
	}
	else if ('TELMEX' == CfgMode.toUpperCase())
	{
		if("0" == key) return '[Log de config]';
		if("1" == key) return '[Log de shell]';
		if("2" == key) return '[Log de alarma]';
	}
	else
	{
		if(curLanguage == "chinese")
		{
			if("0" == key) return '[Config-Log]';
			if("1" == key) return '[Shell-Log]';
			if("2" == key) return '[Alarm-Log]';
		}
		else
		{
			if("0" == key) return '[Config-Log]';
			if("1" == key) return '[Shell-Log]';
			if("2" == key) return '[Alarm-Log]';
		}

	}

	return "All";
}

function CheckForm()
{
	return true;
}

function CancelConfig()
{
	setCheck('LogEnable', SyslogCfg.Enable);
	setSelect('Level', SyslogCfg.Level);
}

function AddSubmitParam(SubmitForm,type)
{
	SubmitForm.addParameter('x.Enable',getCheckVal('LogEnable'));

	SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_Syslog'
					   + '&RequestFile=html/ssmp/userlog/logview.asp');

	setDisable('btnApply',1);
	setDisable('cancelValue',1);
}

function ViewLog()
{
	var Form = new webSubmitForm();
	Form.addParameter('InternetGatewayDevice.X_ATP_SyslogConfig.DisplayLevel',
					  getSelectVal('DisplayLevel'));
	Form.setAction('set.cgi?RequestFile=html/ssmp/userlog/logview.asp');
	Form.submit();
}

function backupSetting()
{
	var Form = new webSubmitForm();
	Form.addParameter('logtype', "opt");
	Form.setAction('logviewdown.cgi?FileType=log&RequestFile=html/ssmp/userlog/logview.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}


function RefreshByLogType()
{
	var OldLogText = top.SaveLogContent;
	var LookLogType = getSelectVal('LogTypeVal');
	setSelect('LogTypeVal', LookLogType);

	var LookLogTypeDes = GetLogTypeDes(LookLogType);

	if("All" == LookLogTypeDes)
	{
		document.getElementById("logarea").value = OldLogText;
		return;
	}

	var ResultLog = OldLogText.split("\n");
	var NewShowLog = "";
	for (var i = 0; i < ResultLog.length -1; i++ )
	{
		if (ResultLog[i] != "\r\n" || ResultLog[i] != "" ||  ResultLog[i] != "\0")
		{
			if (-1 != ResultLog[i].indexOf(LookLogTypeDes))
			{
				NewShowLog += ResultLog[i];
				NewShowLog += "\n";
			}
		}
	}

	document.getElementById("logarea").value = NewShowLog;
}

</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("logview", GetDescFormArrayById(LogviewLgeDes, "s0101"), GetDescFormArrayById(LogviewLgeDes, "s0100"), false);
	</script>
	<div class="title_spread"></div>
	<div class="func_title" BindText="s0b12"></div><!-- function 1: log config -->
	<form id="LogEnableCfgForm"  name="LogEnableCfgForm">
		<table id="LogEnableCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1">
			<li id="LogEnable" RealType="CheckBox"     DescRef="s0b03" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Enable" InitValue="Empty"/>
			<li id="Level"     RealType="DropDownList" DescRef="s0b04" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="x.Level"
				InitValue="[{TextRef:'s0b05',Value:'0'},{TextRef:'s0b06',Value:'1'},{TextRef:'s0b07',Value:'2'},{TextRef:'s0b08',Value:'3'},{TextRef:'s0b09',Value:'4'},{TextRef:'s0b0a',Value:'5'},{TextRef:'s0b0b',Value:'6'},{TextRef:'s0b0c',Value:'7'}]"/>
		</table>
		<script>
			var LogEnableCfgFormList = new Array();
			LogEnableCfgFormList = HWGetLiIdListByForm("LogEnableCfgForm", null);
			var TableClass = new stTableClass("width_per20", "width_per80");
			HWParsePageControlByID("LogEnableCfgForm", TableClass, LogviewLgeDes, null);

			var LogEnableArray = new Array();
			LogEnableArray["Enable"] = SyslogCfg.Enable;
			LogEnableArray["Level"] = SyslogCfg.Level;
			HWSetTableByLiIdList(LogEnableCfgFormList, LogEnableArray, null);
		</script>
		<table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button">
			<tr>
				<td class="table_submit width_per20"></td>
				<td class="table_submit"> 
					<input type="button" name="btnApply"    id="btnApply"    class="ApplyButtoncss buttonwidth_100px"  BindText="s0b0d" onClick="Submit();">
					<input type="button" name="cancelValue" id="cancelValue" class="CancleButtonCss buttonwidth_100px" BindText="s0b0e" onClick="CancelConfig();">
					<input type="hidden" name="onttoken"    id="hwonttoken"  value="<%HW_WEB_GetToken();%>">
				</td>
			</tr>
		</table>
	</form>
	<div class="func_spread"></div>
	<div class="func_title" BindText="s0b0f"></div><!-- function 2: log backup -->
	<div id="backlog">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<input class="ApplyButtoncss buttonwidth_150px_250px" name="button" id="button" type='button'  onClick='backupSetting()' BindText="s0b11" />
				</td>
			</tr>
		</table>
		<div class="button_spread"></div>
		<form id="LogviewsCfgForm" name="LogviewsCfgForm">
			<table id="LogviewsCfgPanel" width="100%" border="0" cellpadding="0" cellspacing="1">
				<li id="LogTypeVal" RealType="DropDownList" DescRef="s0b14" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="LogTypeVal"
				InitValue="[{TextRef:'s0b18',Value:'All'},{TextRef:'s0b15',Value:'0'},{TextRef:'s0b16',Value:'1'},{TextRef:'s0b17',Value:'2'}]" ClickFuncApp="onChange=RefreshByLogType"/>
			</table>
			<script>
				var LogviewsCfgFormList = new Array();
				LogviewsCfgFormList = HWGetLiIdListByForm("LogviewsCfgForm", null);
				var TableClass = new stTableClass("width_per20", "width_per80");
				HWParsePageControlByID("LogviewsCfgForm", TableClass, LogviewLgeDes, null);
			</script>

			<div id="logviews">
				<textarea dir="ltr" name="logarea" id="logarea" class="text_log" wrap="off" readonly="readonly"><%HW_WEB_GetLogInfo();%></textarea>
				<script type="text/javascript">
					var textarea = document.getElementById("logarea");
					textarea.value = textarea.value.replace(new RegExp("�","g"),"");
				</script>
			</div>
		</form>
	</div>
	<script>
		ParseBindTextByTagName(LogviewLgeDes, "div",    1);
		ParseBindTextByTagName(LogviewLgeDes, "input",  2);
	</script>
</body>
</html>
