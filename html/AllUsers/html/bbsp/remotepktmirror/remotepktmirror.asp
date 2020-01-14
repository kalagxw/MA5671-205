<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<title>Remote package mirror</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<style>
.TextBox
{
	width:150px;  
}
</style>
<script language="JavaScript" type="text/javascript">
var MirrorStart = '<%HW_WEB_GetPackageActionFlag();%>';

function OnStartMirror()
{
    var SourceIPAddr = getValue("SIPAddress");
    var DestIPAddr = getValue("DIPAddress");

	if ((SourceIPAddr.length == 0) || (isValidIpAddress(SourceIPAddr) == false))
	{
		AlertEx(remotepktcap_language['bbsp_srcinvalid']);
        return false;
	}
	
    if ((DestIPAddr.length == 0) || (isValidIpAddress(DestIPAddr) == false))
    {
        AlertEx(remotepktcap_language['bbsp_dstinvalid']);
        return false;
    }
    
    setDisable("ButtonStart", "1");
    
    var Form = new webSubmitForm();

    Form.addParameter('x.sip', SourceIPAddr);
    Form.addParameter('x.dip', DestIPAddr);
    Form.addParameter('y.X_HW_Dircetion', 'inbound');
    Form.addParameter('y.X_HW_Mirror', 1);
    Form.addParameter('z.X_HW_Dircetion', 'outbound');
    Form.addParameter('z.X_HW_Mirror', 1);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    Form.setAction('startmirpkgaction.cgi?x=InternetGatewayDevice.X_HW_DEBUG.BBSP.QosMirror&y=InternetGatewayDevice.QueueManagement.Classification&z=InternetGatewayDevice.QueueManagement.Classification&RequestFile=html/bbsp/remotepktmirror/remotepktmirror.asp');   
    Form.submit(); 
}

function OnStopMirror()
{
    if (MirrorStart != '1')
    {
        return;
    }

    var Form = new webSubmitForm();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));

    Form.setAction('stopmirpkgaction.cgi?RequestFile=html/bbsp/remotepktmirror/remotepktmirror.asp');   
    Form.submit(); 
}
var TableClass = new stTableClass("table_title width_per25", "table_right", "", "Select");

function LoadFrame()
{
    if (MirrorStart == '1')
    {
        setDisable("ButtonStart", "1");
		
		getElById("currentstatus").innerHTML = ("<B><FONT class='color_red'>" + remotepktcap_language['bbsp_caping'] + "</FONT><B>");
    }
	else
	{
		getElById("currentstatus").innerHTML = ("<B><FONT class='color_red'>" + remotepktcap_language['bbsp_stop'] + "</FONT><B>");
	}

    var all = document.getElementsByTagName("td");
    for (var i = 0; i <all.length ; i++) 
    {
	var b = all[i];
	if(b.getAttribute("BindText") == null)
	{
	     continue;
	}
	b.innerHTML = remotepktcap_language[b.getAttribute("BindText")];
    }
}

</script>
</head>
<body  class="mainbody" onLoad="LoadFrame();"> 
<script language="JavaScript" type="text/javascript">
HWCreatePageHeadInfo("remotepkmirror", GetDescFormArrayById(remotepktcap_language, "bbsp_mune"), GetDescFormArrayById(remotepktcap_language, "bbsp_remotepktcap_title1"), false);
</script>
<div class="title_spread"></div>

<form id="ConfigForm" style="display:block">
<table border="0" cellpadding="0" cellspacing="0"  width="100%">
<li   id="currentstatus" RealType="HtmlText" DescRef="bbsp_state"        RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="CurrentStatus"   InitValue="Empty"/>
<li   id="SIPAddress"    RealType="TextBox"  DescRef="bbsp_sourceip"     RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.SourceIPAddr"  InitValue="Empty" />                                                                   
<li   id="DIPAddress"    RealType="TextBox"  DescRef="bbsp_desip"        RemarkRef="Empty"     ErrorMsgRef="Empty"    Require="FALSE"    BindField="x.DestIPAddr"  InitValue="Empty"/>                                                                  
</table>
<script>
MirrorConfigFormList = HWGetLiIdListByForm("ConfigForm");
HWParsePageControlByID("ConfigForm", TableClass, remotepktcap_language, null);
</script>
<table cellpadding="0" cellspacing="0"  width="100%" class="table_button"> 
<tr> 
  <td class='width_per25'></td> 
  <td class="table_submit">
	<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>"> 
	<button name="ButtonStart" id="ButtonStart" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnStartMirror();"><script>document.write(remotepktcap_language['bbsp_startmirror']);</script></button>
	<button name="cancelValue" id="cancelValue" type="button" class="CancleButtonCss buttonwidth_100px" onClick="OnStopMirror();"><script>document.write(remotepktcap_language['bbsp_stopmirror']);</script></button> </td> 
</tr>
</table>
</form>  
</body>
</html>
