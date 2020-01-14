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

function getItmsCfgStatus()
{
	if( '0' == stStatus.Result )
	{
		return AcsstatusLgeDes["s0502"];
	}
	else if( '1' == stStatus.Result )
	{
		return AcsstatusLgeDes["s030e"];
	}
	else if( '2' == stStatus.Result )
	{
		return AcsstatusLgeDes["s030f"];
	}
	else if( '99' == stStatus.Result )
	{
		return AcsstatusLgeDes["s0503"];
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
		HWCreatePageHeadInfo("acsremoteopt", GetDescFormArrayById(AcsstatusLgeDes, "s0100"), GetDescFormArrayById(AcsstatusLgeDes, "s0501"), false);
	</script>
	<div class="title_spread"></div>
	<form id="ItmsStatusForm">
		<table id="CnctInfoTable" width="100%" cellspacing="1" cellpadding="0">
			<li id="td3_2" RealType="HtmlText" DescRef="s030c" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="td3_2" InitValue="Empty" />
		</table>
		<script>
			var ItmsStatusFormList = new Array();
			var TableClass = new stTableClass("width_per25", "width_per75");
			ItmsStatusFormList = HWGetLiIdListByForm("ItmsStatusForm", null);

			HWParsePageControlByID("ItmsStatusForm", TableClass, AcsstatusLgeDes, null);

			var ItmsStatusArray = new Array();
			ItmsStatusArray["td3_2"] = getItmsCfgStatus();

			HWSetTableByLiIdList(ItmsStatusFormList, ItmsStatusArray, null);
		</script>
	</form>
</body>
</html>
