<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet" href='../../../resource/<%HW_WEB_Resource(diffcss.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
var StatusNormal            = "on";
var StatusPowerMissing      = "off";

function Battery(domain,status,availcapacity)
{
	this.domain = domain;
	this.Status = status;
	this.availcapacity = availcapacity;
}

var batterys;
var battery;
var BatteryInfoFormList = new Array();
batterys = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_BatteryInfo,Status|AvailCapacity,Battery);%>;
battery = batterys[0];
var BatteryCoul = '<%HW_WEB_GetFeatureSupport(HW_SSMP_FEATURE_BT_COUL);%>';
function LoadFrame()
{ 
	if(BatteryCoul != 0)
	{
		setDisplay('BatteryValueInfoDEFHIDERow', 1);
	}
}
 
function GetLanguageDesc(Name)
{
    return BatteryinfoLgeDes[Name];
}

function GetPowerMode()
{
	if(battery.Status == StatusNormal)
	{
		return GetLanguageDesc("s0103");
	}
	else 
	{
		return GetLanguageDesc("s0104");
	}
}

</script>
</head>

<body class="mainbody" onLoad="LoadFrame();"> 

<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("batteryinfo", "", GetDescFormArrayById(BatteryinfoLgeDes, "s0101"), false);
</script>
<div class="title_spread"></div>
<form id="BatteryInfoForm" name="BatteryInfoForm">
<table id="BatteryInfoFormPanel" class="tabal_bg" width="100%" cellspacing="1" cellpadding="0" border="0"> 
<li id="BatteryCon" RealType="HtmlText" DescRef="s0102" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="BatteryCon" InitValue="Empty" />
<li id="BatteryValueInfoDEFHIDE" RealType="HtmlText" DescRef="s0105" RemarkRef="Empty" ErrorMsgRef="Empty" Require="FALSE" BindField="BatteryValueInfoDEFHIDE" InitValue="Empty" />
</table>
<script>
	var TableClass = new stTableClass("table_title per_30_35", "table_right");
	BatteryInfoFormList = HWGetLiIdListByForm("BatteryInfoForm",null);
	HWParsePageControlByID("BatteryInfoForm",TableClass,BatteryinfoLgeDes,null);
	var BatteryInfoArray = new Array();
	BatteryInfoArray["BatteryCon"] = GetPowerMode();
	BatteryInfoArray["BatteryValueInfoDEFHIDE"] = battery.availcapacity + '%';
	HWSetTableByLiIdList(BatteryInfoFormList,BatteryInfoArray,null);
</script>
</form>

<script>
var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = BatteryinfoLgeDes[c];
}
</script>

</body>
</html>
