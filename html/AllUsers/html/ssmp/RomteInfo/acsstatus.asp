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

function GetReportinfo()
{
	if( '0' == stStatus.InformStatus )
	{
		return AcsstatusLgeDes['s0303'];
	}
	else if( '1' == stStatus.InformStatus )
	{
		return AcsstatusLgeDes['s0304'];
	}
	else if( '2' == stStatus.InformStatus )
	{
		return AcsstatusLgeDes['s0305'];
	}
	else if( '3' == stStatus.InformStatus )
	{
		return AcsstatusLgeDes['s0306'];
	}
	else
	{
		return AcsstatusLgeDes['s0307'];
	}
}

function GetCnnctinfo()
{
	if( '0' == stStatus.AcsCnnctStatus )
	{
		return AcsstatusLgeDes['s0309'];
	}
	else if( '1' == stStatus.AcsCnnctStatus )
	{
		return AcsstatusLgeDes['s030a'];
	}
	else if( '2' == stStatus.AcsCnnctStatus )
	{
		return AcsstatusLgeDes['s030b'];
	}
	else
	{
		return AcsstatusLgeDes['s0307'];
	}
}

function GetCfginfo()
{
	if( '0' == stStatus.Result )
	{
		return AcsstatusLgeDes['s030d'];
	}
	else if( '1' == stStatus.Result )
	{
		return AcsstatusLgeDes['s030e'];
	}
	else if( '2' == stStatus.Result )
	{
		return AcsstatusLgeDes['s030f'];
	}
	else if( '99' == stStatus.Result )
	{
		return AcsstatusLgeDes['s0310'];
	}
	else
	{
		return AcsstatusLgeDes['s0307'];
	}
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("acsstatus", GetDescFormArrayById(AcsstatusLgeDes, "s0100"), GetDescFormArrayById(AcsstatusLgeDes, "s0301"), false);
	</script>
	<div class="title_spread"></div>
	<form id="ACSStatusForm">
		<table id="ACSStatusshowPanel" width="100%" cellspacing="1" cellpadding="0">
			<li id="td1_2" RealType="HtmlText" DescRef="s0302" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td1_2" InitValue="Empty" />
			<li id="td2_2" RealType="HtmlText" DescRef="s0308" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td2_2" InitValue="Empty" />
			<li id="td3_2" RealType="HtmlText" DescRef="s030c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td3_2" InitValue="Empty" />
		</table>
		<script>
			var ACSStatusFormList = new Array();
			var TableClass = new stTableClass("width_per25", "width_per75");
			ACSStatusFormList = HWGetLiIdListByForm("ACSStatusForm", null);

			HWParsePageControlByID("ACSStatusForm", TableClass, AcsstatusLgeDes, null);

			var ACSStatusArray = new Array();
			ACSStatusArray["td1_2"] = GetReportinfo();
			ACSStatusArray["td2_2"] = GetCnnctinfo();
			ACSStatusArray["td3_2"] = GetCfginfo();

			HWSetTableByLiIdList(ACSStatusFormList, ACSStatusArray, null);
		</script>
	</form>
</body>
</html>
