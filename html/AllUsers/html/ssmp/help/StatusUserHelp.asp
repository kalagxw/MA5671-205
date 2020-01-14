<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<script language="javascript" src="../common/ProductCapInfo.asp"></script>
</head>
<body class="mainbody" >
<blockquote>
<script language="javascript"> 
var stProductCapInfo = new stProductFlag("0", "0", "0", "0", "0", "0");
stProductCapInfo = GetProductCapInfo();

if (stProductCapInfo.wlan == 0 && stProductCapInfo.usb == 0)/* 没有WLAN，没有usb */
{
	document.write("<p><b>用户侧信息</b></p><p>包括家庭终端用户侧以太网接口信息。</p>");
}
else if (stProductCapInfo.wlan == 0 && stProductCapInfo.usb == 1)/* 没有WLAN，有usb */
{
	document.write("<p><b>用户侧信息</b></p><p>包括家庭终端用户侧以太网接口信息，USB接口信息。</p>");
}
else if(stProductCapInfo.wlan == 1 && stProductCapInfo.usb == 0)/* 有WLAN，没有usb */
{
	document.write("<p><b>用户侧信息</b></p><p>包括家庭终端用户侧WLAN接口信息，以太网接口信息。</p>");
}
else if (stProductCapInfo.wlan == 1 && stProductCapInfo.usb == 1)/* 有WLAN，有usb */
{
	document.write("<p><b>用户侧信息</b></p><p>包括家庭终端用户侧WLAN接口信息，以太网接口信息，USB接口信息。</p>");
}
</script>

</blockquote>
</body>
</html>

