var pingDnsResultInfo = <%HW_WEB_GetPingDnsResult();%>;

function GetPingDnsResultInfo()
{
	if("1" != "<%HW_WEB_GetFeatureSupport(BBSP_FT_TELMEX);%>")
	{
		pingDnsResultInfo = pingDnsResultInfo.replace(new RegExp(/(\n)/g),'<br>');
	}
	return pingDnsResultInfo;
}
GetPingDnsResultInfo();


