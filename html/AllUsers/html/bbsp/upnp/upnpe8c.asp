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
var enblMainUpnp = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_MainUPnP.Enable);%>';
var enblSlvUpnp = '<%HW_WEB_GetParaByDomainName(InternetGatewayDevice.X_HW_SlvUPnP.Enable);%>';

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
		b.innerHTML = upnp_language[b.getAttribute("BindText")];
	}
}

function LoadFrame()
{
    var enable = (enblMainUpnp=='0')?false:true;

    setCheck('UPnPEnable_checkbox',enable);	

	loadlanguage();
}

function CheckForm(type)
{
	setDisable('Btn_Submit_button', 1);
    setDisable('Btn_Cancel_button', 1);
	return true;
}

function AddSubmitParam(Form,type)
{
   Form.addParameter('x.Enable',getCheckVal('UPnPEnable_checkbox'));
   Form.addParameter('y.Enable',getCheckVal('UPnPEnable_checkbox'));
   Form.addParameter('x.X_HW_Token', getValue('onttoken'));
   Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_MainUPnP'
   	              + '&y=InternetGatewayDevice.X_HW_SlvUPnP'
   	              + '&RequestFile=html/bbsp/upnp/upnpe8c.asp');
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
            <td class="title_common"><label id="UPnP_lable">启用后会开启UPnP功能</label></td> 
          </tr> 
        </table></td> 
    </tr> 
    <tr> 
      <td class="height5p"></td> 
    </tr> 
  </table>
  <table width="100%"   cellpadding="0" cellspacing="1"> 
    <tr > 
      <td class="table_title width_20p"><label id="UPnP">启用UPnP</label></td> 
      <td class="table_right"><input id="UPnPEnable_checkbox" name="UPnPEnable_checkbox" type="checkbox" value="false"></td> 
    </tr> 
  </table> 
  </br>
  <table width="100%"  cellpadding="0" cellspacing="0" class="table_button"> 
    <tr align="right">
      <td class="width_per25"></td> 
      <td> 
	    <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  	<button id="Btn_Submit_button" name="Btn_Submit_button" type="button"  onClick="Submit();">确定</button>
        <button id="Btn_Cancel_button" name="Btn_Cancel_button"  type="button" onClick="CancelConfig();">取消</script></button>
	 </td> 
    </tr> 
  </table> 
</form> 
</body>
</html>
