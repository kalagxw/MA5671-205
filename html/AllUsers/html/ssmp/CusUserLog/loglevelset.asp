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

var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_Syslog, Enable|Level|QueryLevel,stSyslogCfg);%>; 
var SyslogCfg = temp[0];

function LoadFrame()
{     
	if (SyslogCfg.Enable == 1 || SyslogCfg.Enable == "1")
	{
		setCheck('LogEnable_checkbox',1);
	}
	else
	{
		setCheck('LogEnable_checkbox',0);
	}
    setSelect('LevelLog_select', SyslogCfg.Level);
	setSelect('LevelDisplay_select', SyslogCfg.QueryLevel);
}

function CheckForm()
{
    return true; 
}

function AddSubmitParam(SubmitForm,type)
{
    var CheckValue = getCheckVal("LogEnable_checkbox");
    if (1 == CheckValue)
	{
	    SubmitForm.addParameter('x.Enable',1);
	}
	else
    {
	    SubmitForm.addParameter('x.Enable',0);
	}
	
    SubmitForm.addParameter('x.Level',getSelectVal('LevelLog_select'));
	
	SubmitForm.addParameter('x.QueryLevel',getSelectVal('LevelDisplay_select'));

    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_Syslog'
                          + '&RequestFile=html/ssmp/CusUserLog/loglevelset.asp');
    
    setDisable('Configbtnsave_button',1);

}

function LogEnableApply()
{
}
</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<div id="logconfig"> 
<table id="Title_config_log_lable" width="100%" border="0" cellspacing="0" cellpadding="0"> 
<tr> 
	<td class="table_head" width="100%"><lable>系统日志 -- 配置</lable> </td> 
</tr>
<tr> 
<td height="5"></td> 
</tr>		  
<tr> 
	<td class="title_01"  style="padding-left:10px;" width="100%"><lable>如果日志模式已开启，系统将开始记录所有选择的事件。<br>
对于日志等级，所有等于或之上的所选择等级的事件都将被记录。<br>
对于显示等级，所有等于或之上的所选择等级的事件都将被显示。 <br>
选择所要的值，点击“保存/应用”用以配置这些系统日志选项。
</lable> </td> 
</tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
    <tr> 
      <td class="table_title" id="Title_log_lable" width="12%" align="left"><lable>日志:</lable></td> 
<td  class="table_right" width="88%" > <input id='LogEnable_checkbox' name='LogEnable_checkbox'  type='checkbox' onClick="LogEnableApply();"></td>

    </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
    <tr > 
      <td class="table_title"  align="left" width="12%"> 日志等级:</td> 
      <td class="table_right" width="88%"> <select name='LevelLog_select' size="1" id="LevelLog_select"> 
          <option value="0">Emergency</option> 
          <option value="1">Alert</option> 
          <option value="2">Critical</option> 
          <option value="3">Error</option> 
          <option value="4">Warning</option> 
          <option value="5">Notice</option> 
          <option value="6">Informational</option> 
          <option value="7">Debugging</option> 
        </select> </td> 
    </tr>
    <tr > 
      <td class="table_title"  align="left" width="12%"> 显示等级:</td> 
      <td class="table_right" width="88%"> <select name='LevelDisplay_select' size="1" id="LevelDisplay_select"> 
          <option value="0">Emergency</option> 
          <option value="1">Alert</option> 
          <option value="2">Critical</option> 
          <option value="3">Error</option> 
          <option value="4">Warning</option> 
          <option value="5">Notice</option> 
          <option value="6">Informational</option> 
          <option value="7">Debugging</option> 
        </select> </td> 
    </tr> 	
  </table> 
  </table> 
  <table width="100%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
    <tr> 
      <td class="table_submit" width='25%'></td> 
      <td  class="table_submit" align="right">
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  <input  class="submit" name="Configbtnsave_button" id="Configbtnsave_button" type="button" value="保存/应用" onClick="Submit();"> </td> 
    </tr> 
  </table> 
</div> 
</body>
</html>
