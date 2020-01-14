<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" />
<link rel="stylesheet" href="../../../resource/common/<%HW_WEB_CleanCache_Resource(style.css);%>" type="text/css"/>
<link rel="stylesheet"  href='../../../Cuscss/<%HW_WEB_GetCusSource(frame.css);%>' type='text/css'>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(util.js);%>"></script>
<script language="JavaScript" src='../../../Cusjs/<%HW_WEB_GetCusSource(InitFormCus.js);%>'></script>
<script language="JavaScript" src="../../../resource/common/<%HW_WEB_CleanCache_Resource(InitForm.asp);%>"></script>
<title>Firewall Level</title>
<script language="JavaScript" src="../../../resource/<%HW_WEB_Resource(bbspdes.html);%>"></script>
<script language="JavaScript" type="text/javascript">
function stfirewall(domain,enable,config)
{
    this.domain = domain;
	this.enable = enable;
	this.config = config;  
}
var FirewallInfo = <%HW_WEB_GetParaArryByDomain(InternetGatewayDevice.X_HW_Security.Firewall,Enable|Config,stfirewall);%>;  
var curCfgModeWord = '<%HW_WEB_GetCfgMode();%>'; 
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
		b.innerHTML = firewallleveldual_language[b.getAttribute("BindText")];
	}
}

function displayFltsecLevel(IsSelectOption)
{
	var strFirewallLevel = '';
	if (FirewallInfo[0] == null)
	{
		if (false == IsSelectOption)
		{
			strFirewallLevel = firewallleveldual_language['bbsp_Standard'];
		}
		else
		{
			strFirewallLevel = 'Standard';
		}
	}
	else
	{
		if (0 == FirewallInfo[0].enable)
		{
			if (false == IsSelectOption)
			{
				strFirewallLevel = firewallleveldual_language['Disable'];
			}
			else
			{
				strFirewallLevel = 'Disabled';
			}
			
		}
		else if (1 == FirewallInfo[0].enable)
		{
			switch(FirewallInfo[0].config.toUpperCase())
			{
				case 'STANDARD':
				default:
					{
						if (false == IsSelectOption)
						{
							strFirewallLevel = firewallleveldual_language['bbsp_Standard'];
						}
						else
						{
							strFirewallLevel = 'Standard';
						}
					}
					break;
			}
		}
	}
	return strFirewallLevel;
}


function LoadFrame()
{
	setSelect("SecurityLevel", displayFltsecLevel(true));
	loadlanguage();
}

function SubmitForm()
{
	var enable = 1;
	var SecurityLevel = getValue('SecurityLevel');
	var message = '';
	
	switch(SecurityLevel)
	{
		case 'Disabled':
			message = firewallleveldual_language['bbsp_DisabledMode'];
		    break;
		case 'Standard':
			message = firewallleveldual_language['bbsp_StandardMode'];
		    break;
		default:
            break;
	}
	
	if (ConfirmEx(message) == false)
	{
	    return;
    }
	
	if("Disabled" == SecurityLevel) 
	{
		enable = 0;
		SecurityLevel = 'Standard';
	}
	
    var Form = new webSubmitForm(); 
	Form.addParameter('x.Enable',enable);
    Form.addParameter('x.Config',SecurityLevel);
	Form.addParameter('x.X_HW_Token', getValue('onttoken'));
	Form.setAction('set.cgi?x=InternetGatewayDevice.X_HW_Security.Firewall'+ '&RequestFile=html/bbsp/firewallleveldual/firewallleveldual.asp');	
	Form.submit();	
}

</script>
</head>
<body onLoad="LoadFrame();" class="mainbody">
<form id="ConfigForm">
<script language="JavaScript" type="text/javascript">
	HWCreatePageHeadInfo("firewallleveldualtitle", GetDescFormArrayById(firewallleveldual_language, ""), GetDescFormArrayById(firewallleveldual_language, ""), false);
	if(curCfgModeWord.toUpperCase() == "PTVDF")
	{
		  document.getElementById("firewallleveldualtitle_content").innerHTML = firewallleveldual_language['bbsp_firewalllevel_title_short'];
	}else
	{
		  document.getElementById("firewallleveldualtitle_content").innerHTML = firewallleveldual_language['bbsp_firewallleveldual_title'];
	}
</script>
<div class="title_spread"></div>

<table width="100%" border="0" cellpadding="0" cellspacing="1" class="tabal_bg"> 
	 <tr class="table_title">
		<td class='width_per40' BindText='bbsp_currentlevelmh'></td> 
		<td class='width_per60' > 
		<script language="JavaScript">
		   document.write("&nbsp;&nbsp;"+displayFltsecLevel(false));
		</script>
		</td> 
	</tr>       
	 <tr class="table_title">
		<td class='width_per40' BindText='bbsp_setlevelmh'></td>
		<td class='width_per60'>
		<select name="SecurityLevel" id="SecurityLevel">
		<option value="Disabled"><script>document.write(firewallleveldual_language['Disable']);</script>
		<option value="Standard"><script>document.write(firewallleveldual_language['bbsp_Standard']);</script>
		</select>
		</td>
	</tr>
</table>
			
<table id="OperatorPanel" class="table_button" style="width: 100%" cellpadding="0">
  <tr>
  <td class="table_submit width_per40"></td>
  <td class="table_submit">
  <input type="hidden" name="onttoken" id="hwonttoken" value="<%HW_WEB_GetToken();%>">
  <button name="btnApply" id="btnApply" type="button"  onClick="SubmitForm();" class="submit"><script>document.write(firewallleveldual_language['bbsp_app']);</script></button>
  </td>
  </tr>
</table>

</form>
</body>
</html>
