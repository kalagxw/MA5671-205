<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<title>LAN配置帮助</title>
</head>
<body class="mainbody">
<blockquote><b>LAN配置</b>
<script language="javascript">
var DhcpFeature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_DHCP_MAIN);%>";
var Dhcpv6Feature = "<%HW_WEB_GetFeatureSupport(BBSP_FT_IPV6_DHCP6S);%>";
if("1" == DhcpFeature && "1" == Dhcpv6Feature)
{
	document.write("<br>");
	document.write("<p> 用于配置LAN侧IPv4/IPv6管理IP地址和DHCPv4/DHCPv6地址池。</p>");
}
else if("1" == DhcpFeature && "0" == Dhcpv6Feature)
{
	document.write("<br>");
	document.write("<p> 用于配置LAN侧IPv4管理IP地址和DHCPv4地址池。</p>");
}
else if("0" == DhcpFeature && "1" == Dhcpv6Feature)
{
	document.write("<br>");
	document.write("<p> 用于配置LAN侧IPv4/IPv6管理IP地址和DHCPv6地址池。</p>");
}
else
{
	document.write("<br>");
	document.write("<p> 用于配置LAN侧IPv4管理IP地址。</p>");
}
</script>
</blockquote>
</body>
</html>

