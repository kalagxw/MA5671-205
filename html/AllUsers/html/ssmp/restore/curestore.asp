<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" type="text/javascript">
var CfgMode ='<%HW_WEB_GetCfgMode();%>';

function LoadFrame()
{ 
	if ('GDCU' != CfgMode.toUpperCase())
	{
		document.getElementById('divRestoreDefault').style.display= "";
	}
}

function RestoreDefaultCfg()
{
	if(ConfirmEx("如果您恢复了默认配置，您的私有配置将会丢失，并且设备将会自动重启。\n确定要恢复默认配置吗?")) 
	{
		var Form = new webSubmitForm();
		
		setDisable('btnRestoreDftCfg', 1);
		Form.setAction('restoredefaultcfg.cgi?' + 'RequestFile=html/ssmp/reset/reset.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
}

function RestoreDefaultCfgAll()
{
	if(ConfirmEx("如果您恢复了出厂配置，您的私有配置和关键参数将会丢失，并且设备将会自动重启。\n确定要恢复默认出厂配置吗?")) 
	{
		var Form = new webSubmitForm();
		
		setDisable('btnRestoreDftCfgAll', 1);
		Form.setAction('restoredefaultcfgall.cgi?' + 'RequestFile=html/ssmp/reset/reset.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
}
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div> 
	<div id="divRestoreDefault" style="display:none">
	  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
		<tr> 
		  <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
			  <tr> 
				<td class="title_01"  style="padding-left:10px;" width="100%">在本页面上，您可以通过点击“恢复默认配置”使终端设备的配置恢复为默认配置并保留关键参数（如语音、无线参数等）。</td> 
			  </tr> 
			</table></td> 
		</tr> 
	  </table> 
	  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
		<tr> 
		  <td></td> 
		</tr> 
	  </table> 
	  <table width="100%" cellpadding="0" cellspacing="0"> 
		<tr> 
		  <td align="left"> <input  class = "submit" name="btnRestoreDftCfg" id="btnRestoreDftCfg" type='button' style="width:98px" onClick='RestoreDefaultCfg()' value='恢复默认配置'> </td> 
		</tr> 
	  </table> 
	  <table width="100%" height="15" border="0" cellpadding="0" cellspacing="0"> 
		<tr> 
		  <td> </td> 
		</tr> 
	  </table> 
  </div>
  <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
    <tr> 
      <td class="prompt"><table width="100%" border="0" cellspacing="0" cellpadding="0"> 
          <tr> 
            <td class="title_01"  style="padding-left:10px;" width="100%">在本页面上，您可以通过点击“恢复出厂配置”使终端设备的配置完全恢复为出厂时配置。</td> 
          </tr> 
        </table></td> 
    </tr> 
  </table> 
  <table width="100%" height="5" border="0" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td></td> 
    </tr> 
  </table> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td align="left">
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
      	<input  class = "submit" name="btnRestoreDftCfgAll" id="btnRestoreDftCfgAll" type='button' style="width:98px" onClick='RestoreDefaultCfgAll()' value='恢复出厂配置'> 
      </td> 
    </tr> 
  </table> 
</div> 
</body>
</html>
