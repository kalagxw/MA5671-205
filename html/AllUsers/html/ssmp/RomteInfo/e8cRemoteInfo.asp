<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link type='text/css' rel="stylesheet" href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>'>
<link type='text/css' rel="stylesheet" href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>'>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function stRmtMngtStatus(domain, Result, InformStatus, AcsCnnctStatus)
{
	this.domain         = domain;
	this.Result         = Result;
	this.InformStatus   = InformStatus;
	this.AcsCnnctStatus = AcsCnnctStatus;
}

var stStatusArray = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_UserInfo, Result|X_HW_InformStatus|X_HW_AcsCnnctSatus, stRmtMngtStatus);%>;
var stStatus = stStatusArray[0];

function LoadFrame()
{
}

function getItmsReportStatus()
{
	if ('0' == stStatus.InformStatus)
	{
		return AcsstatusLgeDes["s0303"];
	}
	else if ('1' == stStatus.InformStatus)
	{
		return AcsstatusLgeDes["s0304"];
	}
	else if ('2' == stStatus.InformStatus)
	{
		return AcsstatusLgeDes["s0305"];
	}
	else if ('3' == stStatus.InformStatus)
	{
		return AcsstatusLgeDes["s0306"];
	}
	else
	{
		return AcsstatusLgeDes["s0307"];
	}
}
function getItmsConnStatus()
{
	if ('0' == stStatus.AcsCnnctStatus)
	{
		return AcsstatusLgeDes["s0603"];
	}
	else if ('1' == stStatus.AcsCnnctStatus)
	{
		return AcsstatusLgeDes["s030a"];
	}
	else if ('2' == stStatus.AcsCnnctStatus)
	{
		return AcsstatusLgeDes["s0604"];
	}
	else
	{
		return AcsstatusLgeDes["s0307"];
	}
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("itmsstatus", GetDescFormArrayById(AcsstatusLgeDes, "s0100"), GetDescFormArrayById(AcsstatusLgeDes, "s0601"), false);
	</script>
	<div class="title_spread"></div>
	<form id="ItmsStatusForm">
		<table id="table_inform" width="100%" cellspacing="1" cellpadding="0">
			<li id="td1_2" RealType="HtmlText" DescRef="s0302" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td1_2" InitValue="Empty" />
			<li id="td2_2" RealType="HtmlText" DescRef="s0602" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td2_2" InitValue="Empty" />
		</table>
		<script>
			var ItmsStatusFormList = new Array();
			var TableClass = new stTableClass("width_per25", "width_per75");
			ItmsStatusFormList = HWGetLiIdListByForm("ItmsStatusForm", null);

			HWParsePageControlByID("ItmsStatusForm", TableClass, AcsstatusLgeDes, null);

			var ItmsStatusArray = new Array();
			ItmsStatusArray["td1_2"] = getItmsReportStatus();
			ItmsStatusArray["td2_2"] = getItmsConnStatus();

			HWSetTableByLiIdList(ItmsStatusFormList, ItmsStatusArray, null);
		</script>
	</form>
</body>
</html>
