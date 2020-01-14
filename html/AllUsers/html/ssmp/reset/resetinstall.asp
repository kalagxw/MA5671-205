<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
function LoadFrame()
{ 

}
function Reboot()
{
	var ConfirmInfo = '¿Esta seguro de que desea reiniciar el dispositivo?';
	if(ConfirmEx(ConfirmInfo)) 
	{
		setDisable('btnReboot',1);
		
		var Form = new webSubmitForm();
				
		Form.setAction('set.cgi?x=' + 'InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard'
								+ '&RequestFile=html/ssmp/reset/reset_install.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));						
		Form.submit();
	}
}

</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();"> 
<div> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt">
	  	<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_common" >Se realizar&aacute un reinicio del equipo.</td> 
          </tr> 
        </table>
	  </td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> 
	  	<input  value="Reinicio" class="submit" name="btnReboot" id="btnReboot" type='button' onClick='Reboot()' > 
          <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">	  

	  </td> 
    </tr> 
  </table> 
</div> 
</body>
</html>
