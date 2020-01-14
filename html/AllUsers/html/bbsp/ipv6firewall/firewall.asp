<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>IPv6 firewall</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">

function loadlanguage()
{
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = ipv6firewall_language[b.getAttribute("BindText")];
	}
}

var IPv6Firewall = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_Security.X_HW_IPv6FWDFireWallEnable);%>';

function LoadFrame()
{
	setCheck('ipv6firewall',IPv6Firewall);	
	setDisable("ipv6firewall" , ('<%HW_WEB_GetUserType();%>' != '0') ? 1 : 0);
	setDisable("btnApply" , ('<%HW_WEB_GetUserType();%>' != '0') ? 1 : 0);
	setDisable("cancelValue" , ('<%HW_WEB_GetUserType();%>' != '0') ? 1 : 0);
	loadlanguage();
}

function OnFirewallClick()
{
	 if (0 == getCheckVal('ipv6firewall'))
	 {
	 	AlertEx(ipv6firewall_language['bbsp_note']);
	 }
}

function SubmitForm()
{   
	 var Form = new webSubmitForm();
	 Form.addParameter('x.X_HW_IPv6FWDFireWallEnable',getCheckVal('ipv6firewall'));
	 Form.addParameter('x.X_HW_Token', getValue('onttoken'));
     Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security&RequestFile=html/bbsp/ipv6firewall/firewall.asp');
     setDisable('btnApply', 1);
     setDisable('cancelValue', 1);
     Form.submit();   
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="Configure"> 
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("ipv6firewalltitle", GetDescFormArrayById(ipv6firewall_language, ""), GetDescFormArrayById(ipv6firewall_language, "bbsp_firewall_title"), false);
</script>
<div class="title_spread"></div>
  
  <table cellpadding="0" cellspacing="1" class="tabal_bg" width="100%"> 
    <tr> 
      <td class="table_title width_per25" BindText='bbsp_ipv6firewall'></td> 
      <td class="table_right"> <input type="checkbox" id='ipv6firewall' name='ipv6firewall' onclick="OnFirewallClick()"></td> 
    </tr> 
  </table> 
  <table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
    <tr> 
      <td class='width_per25's></td> 
      <td class="table_submit">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	 	<button name="btnApply" id="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="SubmitForm();"><script>document.write(route_language['bbsp_app']);</script></button>
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"><script>document.write(route_language['bbsp_cancel']);</script></button> </td> 
    </tr> 
  </table> 
</form> 
</body>
</html>
