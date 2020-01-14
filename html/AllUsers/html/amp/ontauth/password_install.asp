<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ampdes.html);%>"></script>
<title>ONT Authentication</title>
<script language="JavaScript" type="text/javascript">

var deviceTag = "<%HW_WEB_GetDeviceTag();%>";
 
function CheckForm(type)
{
	var UserCode = getValue('UserCodeValue');
 
	if (14 != UserCode.length)
	{
		alert("Identificador incorrecto. El identificador de ONT debe tener 14 caracteres.");
		return false;
	}
	
	if (false == isHexaNumber(UserCode))
	{
		alert("Identificador incorrecto. El identificador de ONT debe tener 14 caracteres.");
		return false;
	}
	
	return true;
}
 
function convUserCodetoSn(UserCode)
{
	var prefix = "00";
	return prefix+UserCode;
}

function convUserCodetoPwd(UserCode)
{
	var postfix = "000000";
	return UserCode+postfix;
}

function AddSubmitParam(SubmitForm,type)
{	
	SubmitForm.addParameter('x.X_HW_PonHexPassword', convUserCodetoPwd(getValue('UserCodeValue')));
	SubmitForm.addParameter('x.X_HW_PonSN', convUserCodetoSn(getValue('UserCodeValue')));
    
	SubmitForm.addParameter('x.X_HW_ForceSet', 1);
	
	SubmitForm.setAction('set.cgi?' +'x=InternetGatewayDevice.DeviceInfo'
						+ '&RequestFile=html/amp/ontauth/password_install.asp');

    setDisable('btnApply_ex2',1);
    SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));
    SubmitForm.submit();
}

function isHexaNumber(number)
{
    for (var index = 0; index < number.length; index++)
    {
        if (isHexaDigit(number.charAt(index)) == false)
        {
            return false;
        }
    }
    return true;
}

function init()
{
    setText('UserCodeValue', "");
}

function LoadFrame()
{
    init();
	
	var all = document.getElementsByTagName("td");
	for (var i = 0; i <all.length ; i++) 
	{
		var b = all[i];
		if(b.getAttribute("BindText") == null)
		{
			continue;
		}
		b.innerHTML = cfg_ontauth_language[b.getAttribute("BindText")];
	}
	
}

</script>
</head>

<body  class="mainbody" onLoad="LoadFrame();"> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt">
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_common">Introduce el identificador de la ONT y pulsa Registrar.</td> 
          </tr> 
 <tr> 
      <td class="title_common">  
  <div>
  <table>
          <tr> 
            <td class='align_left'><img style="margin-bottom:2px" src="../../../images/icon_01.gif" width="15" height="15" /></td> 
            <td class='align_left'>Atención: </td> 
          </tr>
 </table> 
  <table>
          <tr>  
            <td class='align_left'>La incorrecta introducción de este identificador puede ocasionar la pérdida del servicio.</td> 
          </tr>
 </table>

 </div>
      </td> 
    </tr> 
        </table>
  </td> 
    </tr> 
  </table> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr > 
    <td class="height5p"></td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td> <form id="ConfigForm" action="">
        <table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg">
          <tr id="TrUserCode"> 
            <td class="table_title width_per20" >Identificador de ONT:</td>
		 <td colspan="2" class="table_right"> <input name="UserCodeValue" type="text" id="UserCodeValue" maxlength="14">
			<span class="gray">(El identificador de ONT debe tener 14 caracteres)</span> 
			</td>
          </tr>
            <table id="TblApplySN" width="100%" border="0" cellpadding="0" cellspacing="1">
          <tr> 
            <td> <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table_button">
                <tr > 
                  <td class="table_submit width_per20"></td>
                  <td class="table_submit width_per80"> 
                  	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
                  	<button name="btnApply_ex2" id="btnApply_ex2" type="button" class="submit" onClick="Submit();">Registrar</button>
                  </td>
                </tr>
              </table></td>
          </tr>
        </table>
      </form></td>
  </tr> 
   <tr id="DeviceMarker">
<td class="table_title" id="td14_1">Al pulsar Registrar se procederá a la configuración remota de su equipo. Esta operación puede llevar unos minutos y es posible que se produza el reinicio del equipo.</td>
<script type="text/javascript" language="javascript">
document.write(deviceTag);
</script>
</td>
</tr>

</table>
</body>
</html>
