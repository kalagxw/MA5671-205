<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<title></title>
<script language="JavaScript" type="text/javascript">
var SSLPort ='<%HW_WEB_GetRePortNum();%>';
var SSLHostIp ='<%HW_WEB_GetHostAddr();%>';
function LoadFrame()
{	
	window.location="https://" + SSLHostIp + ":" + SSLPort;
}
</script>
</head>
<body onLoad="LoadFrame();"> 
</body>
</html>
