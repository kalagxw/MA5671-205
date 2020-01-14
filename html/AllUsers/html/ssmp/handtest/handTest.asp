<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Pragma" content="no-cache">
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
<form action='inform.cgi?RequestFile=html/ssmp/handtest/handTest.asp' method="post" enctype="multipart/form-data"  id="ReportForm" onSubmit="return startReport();"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td> 
        <input name="btnStart" id="Manual_inform_button" type="submit" class="submit" value="Inform手动上报">
		<input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>">
		<label id="Title_ manual_inform_tips_lable">（点击后将手动连接ITMS管理平台 ）</label>
		</td> 
    </tr> 
  </table> 
  <div name="reportResult" id="reportResult"></div> 
  <br>
<label id="Title_ manual_inform_view_tips_lable">  
  <div name="resulttext" id="resulttext"></div> 
  </label>
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
		getElement('resulttext').innerHTML = '<B><FONT color=red>上报无回应<br/>原因：家庭网关发起了向ITMS的TCP连接请求，但连接建立失败。</FONT> </B>';
	}
	if(ReportResult=='3')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>上报过程中断<br/>原因：家庭网关向ITMS的TCP连接建立成功，但上报Inform过程未完成。</FONT> </B>';
	}
	if(ReportResult=='4')
	{
		getElement('resulttext').innerHTML = '<B><FONT color=red>未上报<br/>原因：如家庭网关正在启动、无远程管理WAN连接、远程管理WAN连接未生效、无管理通道DNS信息、无ACS配置参数、ACS域名解析失败等。</FONT> </B>';
	}
}

</script> 

</form> 
</body>
</html>
