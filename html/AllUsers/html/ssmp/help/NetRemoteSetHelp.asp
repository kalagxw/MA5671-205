<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<title>远程管理帮助</title>
</head>
<body class="mainbody">
<blockquote>
<script language="javascript">
var curUserType='<%HW_WEB_GetUserType();%>';
if('0' == curUserType)
{
	document.write("<b>ITMS 服务器</b>");
	document.write("<p>如果TR069的自动连接功能是使能的，则可以设置设备的ACS变量参数，实现设备向ACS的注册连接。<br>");
	document.write("使能周期通知：如果使能该设置，则设备会周期性向ACS上报参数。<br>");
	document.write("证书导入：导入运营商提供的认证证书。<br>");
	document.write("周期通知时间间隔：周期性上报的时间间隔，以秒为单位。<br>");
	document.write("周期通知时间：定时上报的时间，时间设置格式，例如:2009-12-20T12:23:34。<br>");
	document.write("ACS URL：连接ACS的地址与端口，如：http://x.x.x.x:port，x.x.x.x为ACS服务器的IP地址或域名，port是连接的端口号。<br><p>");
}

</script>
<p><b>逻辑ID认证</b> 
<p>用于新设备的注册及下发，请不要更改，如果修改逻辑ID导致业务不正常，请重启网关。

<p>
</body>
</html>
