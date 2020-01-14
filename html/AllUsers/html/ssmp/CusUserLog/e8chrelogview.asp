<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>查看日志</title>
<script language="JavaScript" type="text/javascript">


function stSyslogCfg(domain,Enable,Level,QueryLevel)
{
     this.domain = domain;
	this.Enable = Enable;
	this.Level = Level;
	this.QueryLevel = QueryLevel;
}

var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Syslog, Enable|Level|QueryLevel, stSyslogCfg);%>; 
var SyslogCfg = temp[0];


function LoadFrame()
{   

}

function CheckLogView()
{
   window.location="e8clogview.asp";
}

function ClearLog()
{

}

</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div id="logconfig">
<span style="font-size: 12px;font-weight: bold;">日志启用状态：&nbsp;&nbsp;</span>
<span>
<script type="text/javascript">
if( 1== SyslogCfg.Enable)
{
	document.write("日志已启用");
}
else
{
	document.write("日志未启用");
}
</script> 
</span>
<div class="func_spread"></div>
<div class="title_with_desc">系统记录：</div>
<span class="title_01" width="100%">您可以点击“查看日志”来查看系统记录。</span>
<div class="title_spread"></div>
<div>
<input class="submit" name="CheckLog_button" id="CheckLog_button" type="button" value="查看日志" onClick="CheckLogView();">
<input class="submit" style='display:none' name="ClearLog_button" id="ClearLog_button" type="button" value="清除记录" onClick="ClearLog();"> 	 
</div> 

</div> 
</body>
</html>
