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
function GetLanguageDesc(Name)
{
    return CfgfileLgeDes[Name];
}

var CfgMode ='<%HW_WEB_GetCfgMode();%>';

function LoadFrame() 
{
	if ( 'NOS' != CfgMode.toUpperCase())
	{
		document.getElementById('SaveCfgInfo').style.display="";
	}
	
	if (top.SaveDataFlag == 1)
	{
		 top.SaveDataFlag = 0;
		 AlertEx(GetLanguageDesc("s0701"));
	}
}

function SaveSetting() {
	var Form = new webSubmitForm();
	Form.setMethod('POST');
	top.SaveDataFlag = 1;
	Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave' + '&RequestFile=html/ssmp/cfgfile/cfgfileroot.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
}

function SaveandReboot()
{
	if(ConfirmEx(GetLanguageDesc("s0706")))
	{
		setDisable('btnsaveandreboot', 1);
		var Form = new webSubmitForm();		
		Form.setAction('set.cgi?' + 'x=InternetGatewayDevice.X_HW_DEBUG.SSP.DBSave&y=InternetGatewayDevice.X_HW_DEBUG.SMP.DM.ResetBoard' + '&RequestFile=html/ssmp/cfgfile/cfgfileroot.asp');
		Form.addParameter('x.X_HW_Token', getValue('onttoken'));		
		Form.submit();
	}
}            
</script>
</head>
<body class="mainbody" onLoad="LoadFrame();"> 
<div id="saveConfig"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("cfgfileroot", GetDescFormArrayById(CfgfileLgeDes, "s0102"), GetDescFormArrayById(CfgfileLgeDes, "s0707"), false);
</script>
<div class="title_spread"></div> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td id="SaveCfgInfo" style="display:none;"> <input style="width:150px" class="ApplyButtoncss buttonwidth_150px" name="saveconfigbutton" id="saveconfigbutton" type='button' onClick='SaveSetting()' BindText="s0709"> </td> 
      <td> <input style="width:150px" class="ApplyButtoncss buttonwidth_150px" name="btnsaveandreboot" id="btnsaveandreboot" type='button' onClick='SaveandReboot()' BindText="s070a">
	   <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> </td> 
    </tr> 
  </table> 
</div>
<script>
	ParseBindTextByTagName(CfgfileLgeDes, "td",     1);
	ParseBindTextByTagName(CfgfileLgeDes, "input",  2);
</script>

</body>
</html>
