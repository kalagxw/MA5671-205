<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>

<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>UPnP</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>

<script language="JavaScript" type="text/javascript">
var enFullRouting = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.Services.X_HW_E8CIPFwd.IPForwardModeEnabled);%>';


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
		b.innerHTML = fullrouting_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
	
	if (enFullRouting != '')
	{
		setCheck('Enable',enFullRouting);	
	}
	loadlanguage();
}

function CheckForm(type)
{
	setDisable('btnApply', 1);
	setDisable('cancelValue', 1);
	return true;
}

function AddSubmitParam(Form,type)
{
	var  enFullRoutingVal = getCheckVal('Enable'); 
   if(getCheckVal('Enable') == 1)
   {
       AlertEx(fullrouting_language['bbsp_note']);
   }
   Form.addParameter('x.IPForwardModeEnabled',enFullRoutingVal);
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));
   Form.setAction('set.cgi?x=InternetGatewayDevice.Services.X_HW_E8CIPFwd'+ '&RequestFile=' + "html/bbsp/fullrouting/fullrouting.asp");
   Form.submit();
}

function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody"> 
<form id="ConfigForm" action=""> 
  <table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabal_bg"> 
    <tr> 
      <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_common" BindText='bbsp_fullrouting_title'></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class="height5p"></td> 
    </tr> 
  </table> 
  <table width="100%" class="tabal_bg"  cellpadding="0" cellspacing="1"> 
    <tr > 
      <td class="table_title width_25p" BindText='bbsp_enablefullrouting'></td> 
      <td class="table_right"><input id="Enable" name="Enable" type="checkbox"></td> 
    </tr> 
  </table> 
  </br>
  <table width="100%"  cellpadding="0" cellspacing="0" class="table_button"> 
    <tr > 
      <td class="width_25p"></td> 
      <td class="pad_left5p">
	  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	  	<button id="btnApply" name="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="Submit();"><script>document.write(fullrouting_language['bbsp_app']);</script></button>
        <button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="CancelConfig();"> <script>document.write(fullrouting_language['bbsp_cancel']);</script></button>
	 </td> 
    </tr> 
  </table> 
</form> 
</body>
</html>
