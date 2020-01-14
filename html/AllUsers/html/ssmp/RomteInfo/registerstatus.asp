<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title></title>
<link type='text/css' rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>'>
<link type='text/css' rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>'>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
function stResultInfo(domain, Result, Status, Limits, Times, RegTimerState, InformStatus, ProvisioningCode, ServiceNum)
{
	this.domain = domain;
	this.Result = Result;
	this.Status = Status;
	this.Limits = Limits;
	this.Times = Times;
}

var stResultInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|Status|Limit|Times, stResultInfo);%>;
var RegInfos = stResultInfos[0];
</script>
</head>
<body class="mainbody">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("acsregstatus", GetDescFormArrayById(AcsstatusLgeDes, "s0100"), GetDescFormArrayById(AcsstatusLgeDes, "s0401"), false);
	</script>
	<div class="title_spread"></div>
	<form id="RegStatusForm">
		<table id="RegStatusshowPanel" width="100%" cellspacing="1" cellpadding="0">
			<li id="StatusValue" RealType="HtmlText" DescRef="s0402" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Status" InitValue="Empty" />
			<li id="ResultValue" RealType="HtmlText" DescRef="s0403" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Result" InitValue="Empty" />
			<li id="TimesValue"  RealType="HtmlText" DescRef="s0404" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="Times"  InitValue="Empty" />
		</table>
		<script>
			var RegStatusFormList = new Array();
			var TableClass = new stTableClass("width_per25", "width_per75");
			RegStatusFormList = HWGetLiIdListByForm("RegStatusForm", null);

			HWParsePageControlByID("RegStatusForm", TableClass, AcsstatusLgeDes, null);

			var RegStatusArray = new Array();
			RegStatusArray["Status"] = RegInfos.Status;
			RegStatusArray["Result"] = RegInfos.Result;
			RegStatusArray["Times"]  = RegInfos.Times;

			HWSetTableByLiIdList(RegStatusFormList, RegStatusArray, null);
		</script>
	</form>
</body>
</html>
