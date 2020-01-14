<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';
var curWebFrame = '<%HW_WEB_GetWEBFramePath();%>';
function setAllDisable()
{
	setDisable('btnRestoreDftCfg',1);
}
 
 
function GetLanguageDesc(Name)
{
    return RestoreLgeDes[Name];
}

function LoadFrame()
{ 
	if((curWebFrame == 'frame_argentina') &&(curUserType == sysUserType))
	{
		setAllDisable();
	}

}

function RestoreDefaultCfg()
{
	if(ConfirmEx(GetLanguageDesc("s0a01")))
	{
		var Form = new webSubmitForm();
		
		setDisable('btnRestoreDftCfg', 1);
		Form.setAction('restoredefaultcfg.cgi?' + 'RequestFile=html/ssmp/ssmp/reset.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));
		Form.submit();
	}
}


</script>
</head>

<body class="mainbody" onLoad="LoadFrame();"> 
<div>
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("restore", GetDescFormArrayById(RestoreLgeDes, "s0a03"), GetDescFormArrayById(RestoreLgeDes, "s0a02"), false);
</script> 
<div class="title_spread"></div>
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td> 
      	<input  class = "ApplyButtoncss buttonwidth_150px_250px" name="btnRestoreDftCfg" id="btnRestoreDftCfg" type='button' onClick='RestoreDefaultCfg()'  BindText="s0a03" > 
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
      </td> 
    </tr> 
  </table> 
</div> 
<script>
ParseBindTextByTagName(RestoreLgeDes, "td",     1);
ParseBindTextByTagName(RestoreLgeDes, "input",  2);
</script>

</body>
</html>
