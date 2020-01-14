<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function stMonitorDiagnose(domain,Enable,ServerUrl)
{
		this.domain = domain;
		this.Enable = Enable;
		this.ServerUrl = ServerUrl;
}

var temp = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_MonitorCollector, Enable|ServerUrl, stMonitorDiagnose);%>; 

var MonitorDiagnose = temp[0];

function LoadFrame()
{     
	if (MonitorDiagnose.Enable == 1)
	{
		setCheck('MonitorEnable',0);
	}
	else
	{
		setCheck('MonitorEnable',1);
	}
	
	if(MonitorDiagnose.ServerUrl == "")
	{
		document.getElementById("ServerUrl").innerHTML = "--";
	}
	else
	{
		document.getElementById("ServerUrl").innerHTML = MonitorDiagnose.ServerUrl;
	}
}

function CheckForm()
{
    return true; 
}

function CancelConfig()
{
	 LoadFrame();
}

function SubmitForm()
{
    var Form = new webSubmitForm();
	var MonitorValue = getCheckVal('MonitorEnable');
	if (MonitorValue == 1 && MonitorDiagnose.Enable == 1)
	{
		Form.addParameter('x.Enable',0);
	}
	else if((MonitorValue == 1 && MonitorDiagnose.Enable == 0)
	  		||(MonitorValue == 0 && MonitorDiagnose.Enable == 1))
	{
		return true;
	}
	else
	{
		AlertEx("监控已经禁用，不能再恢复！");
		LoadFrame();
		return false;
	}
	
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	
	Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_MonitorCollector'
	                      + '&RequestFile=html/ssmp/monitor/monitordiagnose.asp');
	
	setDisable('btnApply', 1);
	setDisable('cancelValue', 1);
	Form.submit();   
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_01"  style="padding-left:10px;" width="100%"> <font face="Arial"> 在本页面，您可以禁用智能诊断，使家庭网关不再向服务器上传状态信息文件。</font> </td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
    <tr> 
      <td class="table_title" width="18%" align="left">当前状态:</td> 
			<td  class="table_right" width="88%" >
				<script language="javascript">
				if (MonitorDiagnose.Enable == 1)
				{
					document.write("已开启");
				}
				else
				{
					document.write('已禁用');
				}
				</script>
			</td>

    </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
    <tr > 
      <td class="table_title"  align="left" width="18%"> 服务器地址:</td> 
			<td class="table_right" width="88%"><span id="ServerUrl"></span></td> 
    </tr> 
  </table> 
  <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_bg"> 
    <tr > 
      <td class="table_title"  align="left" width="18%"> 监控禁用:</td> 
      <td class="table_right" width="88%"><input id="MonitorEnable" name="MonitorEnable" type="checkbox"></td> 
    </tr> 
  </table> 
  </table> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table_button"> 
    <tr> 
      <td class="table_submit" width='25%'></td> 
      <td  class="table_submit" align="right">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	 	<input  class="submit" name="btnApply" id="btnApply" type="button" value="应用" onClick="SubmitForm();"> 
        <input class="submit" name="cancelValue" id="cancelValue" type="button" value="取消" onClick="CancelConfig();"> </td> 
    </tr> 
  </table> 
</body>
</html>
