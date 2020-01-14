<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />

<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">

function ONTInfo(domain,BANDAccess,IPTVAccess,VOIPAccess)
{
	this.domain             = domain;
	this.BANDAccess 		= BANDAccess;
	this.IPTVAccess			= IPTVAccess;
	this.VOIPAccess			= VOIPAccess;
}
var ontInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.DeviceInfo.X_HW_ServiceAccessInfo,BANDAccess|IPTVAccess|VOIPAccess,ONTInfo);%>;

function LoadFrame()
{
	setText('BANDAccess',ontInfos[0].BANDAccess);
	setText('IPTVAccess',ontInfos[0].IPTVAccess);
	setText('VOIPAccess',ontInfos[0].VOIPAccess);
}

function AddSubmitParamInfo()
{
	var Form = new webSubmitForm();
    Form.addParameter('x.BANDAccess',getValue('BANDAccess'));
    Form.addParameter('x.IPTVAccess',getValue('IPTVAccess'));
    Form.addParameter('x.VOIPAccess',getValue('VOIPAccess'));
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
 
    Form.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_ServiceAccessInfo'
                   + '&RequestFile=html/ssmp/bss/e8cbss.asp');
				   
	Form.submit();
	   
    setDisable('btnApply',1);
    setDisable('cancelValue',1);
}

function CancelConfig()
{
	setText('BANDAccess',ontInfos[0].BANDAccess);
	setText('IPTVAccess',ontInfos[0].IPTVAccess);
	setText('VOIPAccess',ontInfos[0].VOIPAccess);
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div id="businessInfo"> 
  <table width="80%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
    <tr class="head_title"> 
      <td width="40%">业务名称</td> 
      <td width="40%">业务值</td> 
    </tr> 
    <tr class="head_title"> 
      <td>宽带接入号码</td> 
      <td> <input name='BANDAccess' type='text' id="BANDAccess" size="24" maxlength="255"> </td> 
    </tr> 
    <tr class="head_title"> 
      <td>IPTV接入号码</td> 
      <td> <input name='IPTVAccess' type='text' id="IPTVAccess" size="24" maxlength="255"> </td> 
    </tr> 
    <tr class="head_title"> 
      <td>VOIP接入号码</td> 
      <td> <input name='VOIPAccess' type='text' id="VOIPAccess" size="24" maxlength="255"> </td> 
    </tr> 
  </table>  
  <table width="80%" border="0" cellspacing="1" cellpadding="0" class="table_button"> 
  <tr> 
    <td class="table_submit" width="15%"></td>
    <td class="table_submit" align="right"> 
	  <input  class="submit" name="btnApply" id= "btnApply" type="button" value="应用" onClick="AddSubmitParamInfo();"> 
	  <input class="submit" name="cancelValue" id="cancelValue" type="button" value="取消" onClick="CancelConfig();"> 
	  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">	  
	</td> 
  </tr> 
</table> 
</div> 
</body>
</html>
