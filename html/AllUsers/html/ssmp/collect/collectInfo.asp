<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<script src="../../../resource/common/<%HW_WEB_CleanCache_Resource(jquery.min.js);%>" type="text/javascript"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(ssmpdes.html);%>"></script>
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" type="text/javascript">
var collectStatus = "";
function setButtonStatus()
{
	$.ajax({
		type : "POST",
		async : false,
		cache : false,
		url : "../common/getCollectStatus.asp",
		success : function(data) {
			 collectStatus  = data;
		}
	});
	if("0" == collectStatus)
	{
		setDisable('collect',0);
		setDisable('view', 1);
		getElement('CollectInfo').innerHTML = '';
		return;
	}
	else if("1" == collectStatus)
	{
		setDisable('collect',1);
		setDisable('view', 1);
		getElement('CollectInfo').innerHTML = '<B><FONT color=red>'+GetLanguageDesc("s1119")+ '</FONT><B>';		
		return;
	}
	else
	{
		setDisable('collect',0);
		setDisable('view', 0);
		getElement('CollectInfo').innerHTML = '<B><FONT color=red>'+GetLanguageDesc("s1120")+ '</FONT><B>';		
		return;
	}
}

function LoadFrame()
{
	setButtonStatus();
	setInterval(function() {
		try 
		{
			 setButtonStatus();
		}
	    catch (e) 
		{
	
		}
	}, 1000*5);
}

function CheckForm()
{
    return true; 
}

function AddSubmitParam(SubmitForm,type)
{

	SubmitForm.addParameter('FaultCmdParams', "-1");
	SubmitForm.addParameter('FaultType', "-1");
	SubmitForm.setAction('collectFaultInfo.cgi?RequestFile=html/ssmp/collect/collectInfo.asp');
}

function viewFalutInfo()
{
	var Form = new webSubmitForm();
	Form.setAction('colleInfodown.cgi?FileType=fault&RequestFile=html/ssmp/collect/collectInfo.asp');
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.submit();
	
	setDisable('view', 1);
}

</script>
</head>

<body class="mainbody" onload="LoadFrame();"> 
<div id="faultInfo"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("collectInfoasp", GetDescFormArrayById(CollectInfoLgeDes, "s1101"), GetDescFormArrayById(CollectInfoLgeDes, "s1102"), false);
</script> 
<div class="title_spread"></div>
<div class="func_title" BindText="s1101"></div> 
<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg" style="margin-top:15;display:none"> 
</table> 
<div id="CollectFaultInfo"> 
  <table width="100%" cellpadding="0" cellspacing="0"> 
    <tr> 
      <td>
		<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">	  
	  	<input class="ApplyButtoncss buttonwidth_150px pix_70_120" name="button" id="collect" type='button' onClick='Submit()' BindText="s1104" />
		<input class="ApplyButtoncss buttonwidth_150px pix_90_130" name="button" id="view" type='button' onClick='viewFalutInfo()' BindText="s1114" /> </td> 
    </tr> 
  </table> 
</div> 
<div class="func_spread"></div>
<div id="CollectInfo"></div> 
<script>
function GetLanguageDesc(Name)
{
    return CollectInfoLgeDes[Name];
}

ParseBindTextByTagName(CollectInfoLgeDes, "td",     1);
ParseBindTextByTagName(CollectInfoLgeDes, "div",    1);
ParseBindTextByTagName(CollectInfoLgeDes, "input",  2);
</script>

</body>
</html>
