<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>Firewall Log</title>
<script language="JavaScript" type="text/javascript">



function LoadFrame()
{     

}


function backupSetting()
{
  var Form = new webSubmitForm();
	Form.addParameter('logtype', "opt");
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('downloadfile.cgi?FileType=flowlog&RequestFile=html/bbsp/firewalllog/firewalllogview.asp');
	Form.submit();
}


</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("firewalllog", GetDescFormArrayById(firewalllogviewLgeDes, "s0b0e"), GetDescFormArrayById(firewalllogviewLgeDes, "s0b10"), false);
</script> 
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tabal_head"> 
  <tr> 
    <td class="width_per100" BindText="s0b0f"></td> 
  </tr> 
</table> 
<table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
  <tr> 
    <td></td> 
  </tr> 
</table> 
<div id="backlog"> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> 
	  <input class="ApplyButtoncss filebuttonwidth_100px" name="button" id="button" type='button'  onClick='backupSetting()' BindText="s0b11" >  
	  <input type="hidden" name="onttoken" id="onttoken" value="<%HW_WEB_GetToken();%>">
	  </td> 
    </tr> 
  </table> 
</div> 
<div class="button_spread"></div>

<div id="logviews"> 
  <textarea name="logarea" id="logarea" class="text_log" wrap="off" readonly="readonly"><%HW_WEB_GetFlowLogInfo();%>
  </textarea> 
	<script type="text/javascript">
		var textarea = document.getElementById("logarea");
		textarea.value = textarea.value.replace(new RegExp("�","g"),"");
	</script> 
</div> 

<script>

 
function GetLanguageDesc(Name)
{
    return firewalllogviewLgeDes[Name];
}

var all = document.getElementsByTagName("td");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = firewalllogviewLgeDes[c];
}

var all = document.getElementsByTagName("input");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.value = firewalllogviewLgeDes[c];
}

var all = document.getElementsByTagName("option");
for (var i = 0; i < all.length; i++)
{
    var b = all[i];
	var c = b.getAttribute("BindText");
	if(c == null)
	{
		continue;
	}
    b.innerHTML = firewalllogviewLgeDes[c];
}
</script>

</body>
</html>
