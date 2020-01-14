<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet"  href='../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>' type='text/css'>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>

<title>Port Isolate</title>
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
		b.innerHTML = portisolate_language[b.getAttribute("BindText")];
	}
}

function stIsolateInfo(domain,enable)
{
    this.domain = domain;
	this.enable = enable;
}

var IsolateInfos = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_AMPConfig.PortIsolate, PortIsolateSwitch,stIsolateInfo);%>; 
var IsolateSwitch = IsolateInfos[0];

//loadpage

function LoadFrame()
{	
 	if ( null != IsolateSwitch )
	{
	    if ( "enable" == IsolateSwitch.enable )
		{
			setCheck('PortIsolateEn',1);
		}
		else
		{
			setCheck('PortIsolateEn',0);
		}
	}

	if(top.curUserType != top.sysUserType)
    {
		setDisable("PortIsolateEn",1);		
		setDisable("btnApply",1);
		setDisable("cancelValue",1);
	}

	loadlanguage();	
}

function OnApply()
{
	var Form = new webSubmitForm();
	var val = getCheckVal('PortIsolateEn');
	
	if( 0 == val )
	{
		Form.addParameter('x.PortIsolateSwitch',"disable");	
	}
	else
	{
		Form.addParameter('x.PortIsolateSwitch',"enable");
	}
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?' +'x=InternetGatewayDevice.X_HW_AMPConfig.PortIsolate' + '&RequestFile=html/bbsp/portisolate/portisolate.asp');
	Form.submit();
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
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
<form id="ConfigForm" action="">
	<script language="JavaScript" type="text/javascript">
		HWCreatePageHeadInfo("portisolatetitle", GetDescFormArrayById(portisolate_language, ""), GetDescFormArrayById(portisolate_language, "bbsp_portisolate_title"), false);
	</script>
  <table cellpadding="0" cellspacing="1" width="100%" class="tabal_bg"> 
    <tr> 
      <td class="table_title width_per25" BindText='bbsp_enableportisolate'></td> 
	  <td class="table_right"> 
          <input type='checkbox' id='PortIsolateEn' name='PortIsolateEn' />
      </td>
    </tr> 
  </table> 
  <table cellpadding="0" cellspacing="1" width="100%" class="table_button"> 
    <tr> 
	       <td class='width_per25'></td>
            <td class="table_submit">
        <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
	  	<button id="btnApply" name="btnApply" type="button" class="ApplyButtoncss buttonwidth_100px" onClick="OnApply();"><script>document.write(alg_language['bbsp_app']);</script></button> 
        <button name="cancelValue" id="cancelValue" class="CancleButtonCss"  type="button" onClick="CancelConfig();"><script>document.write(alg_language['bbsp_cancel']);</script></button>
	</td> 
    </tr> 
        <tr> 
        	<td  style="display:none"> <input type='text'> </td> 
        </tr>
  </table> 
</form> 
<!-- InstanceEndEditable --> 
</body>
<!-- InstanceEnd -->
</html>
