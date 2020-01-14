<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var ReportResult = <%HW_WEB_GetInformResult();%>;

function startReport()
{
    with (getElement('ReportForm'))
    {
			setDisable('btnStart',1);
			getElement('reportResult').innerHTML 
			  = '<B><FONT color=red>正在进行inform上报，请稍候...'+ '</FONT><B>';
			getElement('resulttext').innerHTML = '';
		}
	return true;
}

function LoadFrame()
{
}

</script>
</head>
<body class="mainbody"> 
<form action='inform.cgi?RequestFile=html/ssmp/handtest/CuhandTest.asp' method="post" enctype="multipart/form-data"  id="ReportForm" onSubmit="return startReport();"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="tabTest"> 
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td width="100%"  class="title_01" style="padding-left:10px;"> 在本页面上，您可以通过点击“手动上报”按钮，进行手动上报测试。 </td> 
        </tr> 
      </table></td> 
  </tr> 
</table> 

  <table width="100%" height="8" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> </td> 
    </tr> 
  </table> 
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td> 
        <input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>">	  
        <input name="btnStart" id="btnStart" type="submit" class="submit" value="手动上报"> </td> 
    </tr> 
  </table> 
  <div name="reportResult" id="reportResult"></div> 
  <br> 
  <div name="resulttext" id="resulttext"></div> 
  <br> 
  <script language="JavaScript" type="text/javascript">

if (ReportResult != 'none')
{
	if (ReportResult=='1')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>上报成功。</FONT></B>';
	}
	if(ReportResult=='2')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>上报无回应<br/>原因：家庭网关发起了向RMS的TCP连接请求，但连接建立失败。</FONT> </B>';
	}
	if(ReportResult=='3')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>上报过程中断<br/>原因：家庭网关向RMS的TCP连接建立成功，但上报Inform过程未完成。</FONT> </B>';
	}
	if(ReportResult=='4')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>未上报<br/>原因：如家庭网关正在启动、无远程管理WAN连接、远程管理WAN连接未生效、无管理通道DNS信息、无RMS配置参数、RMS域名解析失败等。</FONT> </B>';
	}
}

</script> 
</form> 
</body>
</html>
