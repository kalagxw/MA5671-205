<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<title>ip_protocal_mode</title>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(tabdes.js);%>"></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
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
		b.innerHTML = ip_protocal_mode_language[b.getAttribute("BindText")];
	}
}

var IPProtVerMode = <%HW_WEB_GetParaByDomainName(InternetGatewayDevice.DeviceInfo.X_HW_IPProtocolVersion.Mode);%>;
var sysUserType = '0';
var curUserType = '<%HW_WEB_GetUserType();%>';

function GetIPProtVer()
{
    return IPProtVer;
}


function LoadFrame()
{
	setSelect('IPVersion', IPProtVerMode);
	
	if (curUserType != sysUserType)
	{
		setDisable('IPVersion' , 1);
		setDisable('btnApply',1);
    	setDisable('cancelValue',1);
	}
	loadlanguage();
}

function CheckForm(type)
{
	return true;
}


function AddSubmitParam(SubmitForm,type)
{
	var SelectVal = getSelectVal('IPVersion');

	if (SelectVal != IPProtVerMode)
	{
		AlertEx(ip_protocal_mode_language['bbsp_note1']);
	}
	
	SubmitForm.addParameter('x.Mode', SelectVal);
	SubmitForm.addParameter('x.X_HW_Token', getValue('onttoken'));   
    SubmitForm.setAction('set.cgi?x=InternetGatewayDevice.DeviceInfo.X_HW_IPProtocolVersion&RequestFile=html/bbsp/ipprotocalmode/ipprotocalmode.asp');
    setDisable('btnApply',1);
    setDisable('cancelValue',1);
}


function CancelConfig()
{
    LoadFrame();
}
</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm" action="../network/set.cgi">
<table width="100%"  border="0" cellpadding="0" cellspacing="0" id="tabTest">
  <tr> 
    <td class="prompt"> <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr> 
          <td class='title_common' BindText='bbsp_title'></td> 
        </tr> 
      </table></td> 
  </tr>
	<tr><td height="5px"></td></tr>
</table>

    <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg">
        <tr> 
            <td width="25%" class="table_title"><script>document.write(ip_protocal_mode_language['bbsp_title2'])</script></td>
            <td width="75%" class="table_right">
            	<select id="IPVersion" name="IPVersion" style="width: 135px">
                  <option value="1">IPv4</option>
                  <option value="2">IPv6</option>
				  <option value="3">IPv4/IPv6</option>
              </select> 
            </td>
        </tr>
    </table>
     <table width="100%" class="table_button">
     	<tr align="right">
            <td class='width_15p'> </td> 
            <td > 
				<input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
            	<button id="ButtonApply"  type="button" onClick="Submit();"" class="ApplyButtoncss buttonwidth_100px" >
            		<script>document.write(ip_protocal_mode_language['bbsp_app']);
            			</script>		
            	</button>
              <button id="ButtonCancel" type="button" onClick="CancelConfig();"" class="CancleButtonCss buttonwidth_100px" >
              	<script>document.write(ip_protocal_mode_language['bbsp_cancel']);</script>
              </button> 
            </td>           
        </tr>        
    </table>

</form>

</body>
</html>
