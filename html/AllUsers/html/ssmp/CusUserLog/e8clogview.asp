<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
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

var LogLevelInfo = ["[Emergency", "[Alert", "[Critical", "[Error", "[Warning", "[Notice", "[Informational", "[Debug"];

function LoadFrame()
{   

}
function CheckLogLevel( LineLogText, LookLogLevel )
{
	var LevelInfoLength = LogLevelInfo.length;
	var i = parseInt(LookLogLevel,10) + 1;
	
	for (; i < LevelInfoLength ; i++)
	{   
	    if ( -1 != LineLogText.indexOf(LogLevelInfo[i]) )
		{
			return false;
		}
	}
	
	return true;
}

function RefreshByLogType()
{

	var OldLogText = document.getElementById("logarea").value;

	var QueryLevel = SyslogCfg.QueryLevel;
	
	var ResultLog = OldLogText.split("\n");
   
	var NewShowLog = "";
	var blankLineFlag = false;
	var IDtable = 1;
	for (var i = 0; i < ResultLog.length -2; i++ )
	{
		if(false == blankLineFlag )
		{
			 NewShowLog += ResultLog[i];
			 NewShowLog += "\n<br>";
			 if(ResultLog[i] == "\r" || ResultLog[i]== "")
			 {
			 	blankLineFlag = true;
				
				document.getElementById('Syslogtitle').innerHTML = NewShowLog;
			 }
		}
		else
		{
			if (ResultLog[i] != "\r\n" || ResultLog[i] != "" ||  ResultLog[i] != "\0")
			{
				if ((true == CheckLogLevel(ResultLog[i], QueryLevel)))
				{
					NewShowLog += ResultLog[i];
					NewShowLog += "\n";
					var loginof =ResultLog[i];
					var logtime = loginof.split("[");

					var temp = loginof.split("]");
					
					var loglevel = loginof.substring(logtime[0].length+1,temp[0].length);
		            var logalert = loginof.substring(temp[0].length+1,loginof.length);		
					var id_time = "log_2_" + (IDtable++) + "_table";
					var id_device = "log_2_" + (IDtable++) + "_table";
					var id_critical= "log_2_" + (IDtable++) + "_table";
					var id_alert= "log_2_" + (IDtable++) + "_table";
				    
					document.write('<tr class="tabal_center01 ">');	
					document.write('<TD id=' + id_time +'>' + logtime[0] + '</TD>');
					document.write('<TD id=' + id_device + '>' + 'user' + '</TD>');	
					document.write('<TD id=' + id_critical+ '>' + loglevel + '</TD>');
                    document.write('<TD id=' + id_alert + ' title="'+logalert+'">'+GetStringContent(logalert, 64)+'</TD>');  					
                    document.write('</tr>');						
				}
			}
		}
	}
}

function CheckLogView()
{
   setDisplay('DivLogView', 1);
}

function ClearLog()
{
   
}

function AccRefreshSubmit()
{
   window.location="e8clogview.asp";

}
function AccCloseSubmit()
{
   setDisplay('DivLogView', 0);
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
<div class="title_01" width="100%">您可以点击“查看日志”来查看系统记录。</div>

<div class="func_spread"></div>
<div class="button_spread"></div>
<div><input class="submit" name="CheckLog_button" id="CheckLog_button" type="button" value="查看日志" onClick="CheckLogView();">
	 <input class="submit" style='display:none' name="ClearLog_button" id="ClearLog_button" type="button" value="清除记录" onClick="ClearLog();"> 
</div>	 

<div id="DivLogView">
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
<div class="func_spread"></div>

<tr> 
<td><span style="font-size: 12px;font-weight: bold;"><lable>系统日志&nbsp;&nbsp;</lable></span>
</tr> 
<tr>
<td id="Syslogtitle" style="font-size: 12px;font-weight: bold;"></td>
</tr>
</table> 
<div id="logviews" align="center" style="display:none"> 
  <textarea name="logarea" id="logarea" style="width:100%;height:330px;margin-bottom:20px;" wrap="off" ><%HW_WEB_GetLogInfo();%>
</textarea> 
  <script type="text/javascript">
		var textarea = document.getElementById("logarea");
		textarea.value = textarea.value.replace(new RegExp("�","g"),"");
	 </script> 
</div>
 <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" id="SysLogInst">
  <tr class="head_title">
        <td class="width_5p" id="log_1_1_table"><div class="align_center">日期/时间</div></td>
        <td class="width_3p" id="log_1_2_table"><div class="align_center">设备</div></td>
        <td class="width_3p" id="log_1_3_table"><div class="align_center">严重程度</div></td>
        <td class="width_17p" id="log_1_4_table"><div class="align_center">消息</div></td>
      </tr>
	  <script language="JavaScript" type="text/javascript">
	  RefreshByLogType();
	  </script>
  </table>
  
    <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
    <tr> 
      <td class="table_submit" width='25%'></td> 
      <td  class="table_submit" align="right"> 
	  <input class="submit" name="AccRefresh_button" id="AccRefresh_button" type="button" value="刷新" onClick="AccRefreshSubmit();">
	 <input class="submit" name="AccClose_button" id="AccClose_button" type="button" value="关闭" onClick="AccCloseSubmit();">	  
	  </td> 
    </tr> 
  </table> 
</div> 
</div> 
</body>
</html>
