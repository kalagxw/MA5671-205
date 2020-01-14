<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="opensoftware.html"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<style>
a:link {
	color: #000000;
	text-decoration: none;
}
a:visited {
	color: #000000;
	text-decoration: underline;
}
</style>
<script language="JavaScript" type="text/javascript">
function GetSoftNoticeDesDesc(Name)
{
	return SoftNoticeDes[Name];
}

var CfgModeWord ='<%HW_WEB_GetCfgMode();%>';
var productName = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.ModelName);%>';

function LoadFrame()
{
	if(productName.toUpperCase() == "HG8045D"
	  || productName.toUpperCase() == "HN8055Q")
	{
		document.getElementById('InstallInfo_tr').style.display="";
		document.getElementById('InstallInfo_td').innerHTML=GetSoftNoticeDesDesc("s2025");
	}
	else
	{
		document.getElementById('InstallInfo_tr').style.display="";
		document.getElementById('InstallInfo_td').innerHTML=GetSoftNoticeDesDesc("s20258040H");
	}
}

function Goback()
{
	window.location="/index.asp";
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();">
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head">
		<tr>
			<td width="5%" align="left"> <img src="../../../images/icon_s011.gif" width="20" height="20" />
			<td width="95%" align="left" BindText="s2017"></td>
		</tr>
	</table>
	<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<tr><td class="table_title width_per30" BindText="s2018"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2019"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2020"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2021"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2022"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2023"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2024"></td></tr>
		<tr id="InstallInfo_tr" name="InstallInfo_tr" style="display:none"><td id="InstallInfo_td" name="InstallInfo_td" class="table_title width_per30"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2026"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2027"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2028"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2029"></td></tr>
		<tr><td class="table_title width_per30" BindText="s2030"></td></tr>
	</table>

	<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
		</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head">
		<tr>
			<td width="5%" align="left"> <img src="../../../images/icon_s011.gif" width="20" height="20" />
			<td class="width_per100" BindText="s2031"></td>
		</tr>
	</table>
	<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
		</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<tr><td  class="table_title width_per30"  BindText="s2032"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2033"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2034"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2035"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2036"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2037"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2038"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2039"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2040"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2041"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2043"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2044"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2045"></td></tr>
		<tr><td  class="table_title width_per30"  BindText="s2046"></td></tr>
	</table>

	<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0">
		<tr><td></td></tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="0"  class="tabal_head">
		<tr>
			<td width="5%" align="left"> <img src="../../../images/icon_s011.gif" width="20" height="20" />
			<td class="width_per100" BindText="s2047"></td>
		</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="1">
		<tr><td class="table_title width_per30" BindText="s2048"></td></tr>
	</table>

	<table width="100%" height="20" border="0" cellpadding="0" cellspacing="0">
		<tr><td></td></tr>
	</table>
	<script>
		ParseBindTextByTagName(SoftNoticeDes, "td",    1);
		ParseBindTextByTagName(SoftNoticeDes, "input", 2);
	</script>
</body>
</html>
